 SELECT builds."buildId",
    builds."dModel",
    builds."tModel",
    LEAST(COALESCE(modelcount.count, 0::bigint), COALESCE(matcount.minmat, 0::bigint)) AS amout
   FROM builds
     LEFT JOIN ( SELECT sns.dmodel,
            count(sns."snsId") AS count
           FROM sns
          WHERE sns.condition = 2 AND sns.shiped = false AND sns.order = 51 /*номер заказа*/
          GROUP BY sns.dmodel) modelcount ON builds."dModel" = modelcount.dmodel
     LEFT JOIN ( SELECT "buildMatList"."billdId" AS build,
            min(matsamout.sum / "buildMatList".amout) AS minmat
           FROM "buildMatList"
             LEFT JOIN ( SELECT mats.name,
                    sum(mats.amout) AS sum
                   FROM mats
                  GROUP BY mats.name) matsamout ON "buildMatList".mat = matsamout.name
          GROUP BY "buildMatList"."billdId") matcount ON matcount.build = builds."buildId"
		  INNER JOIN (SELECT model FROM "orderList"
				WHERE "orderId" = 51/*номер заказа*/)ordermodel ON ordermodel.model = builds."tModel"
		  INNER JOIN "dModels" ON "dModels".build = builds."buildId" /* удалить для проверки по всем сборкам */
  WHERE builds."buildId" <> '-1'::integer AND LEAST(COALESCE(modelcount.count, 0::bigint), COALESCE(matcount.minmat, 0::bigint)) > 0
  