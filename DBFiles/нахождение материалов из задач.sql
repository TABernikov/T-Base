SELECT "buildMatList".AMOUT * SUM(BUILDEQ.AMOUT) AS AMOUT,
	"buildMatList".MAT,
	"matsName".NAME
FROM PUBLIC."buildMatList"
INNER JOIN
	(SELECT COALESCE(EQ."build",-1) AS BUILD,
			SUM(MONTHONE.AMOUT) - SUM(MONTHONE.DONE) AS AMOUT
		FROM
			(SELECT "taskWorkList".TMODEL,
					SUM("taskWorkList".AMOUT) AS AMOUT,
					SUM("taskWorkList".DONE) AS DONE
				FROM PUBLIC."taskWorkList"
				LEFT JOIN TASKS ON TASKS.ID = "taskWorkList"."taskId"
				WHERE TASKS.ID = 3
					OR TASKS.ID = 17 /*условие выбора задач*/
				GROUP BY TMODEL)MONTHONE
		LEFT JOIN
			(SELECT "dModels"."build",
					BUILDS."tModel"
				FROM "dModels"
				LEFT JOIN BUILDS ON BUILDS."buildId" = "dModels"."build")EQ ON MONTHONE.TMODEL = EQ."tModel"
		GROUP BY BUILD)BUILDEQ ON BUILDEQ.BUILD = "buildMatList"."billdId"
LEFT JOIN PUBLIC."matsName" ON "matsName"."matNameId" = "buildMatList".MAT
GROUP BY MAT,"buildMatList".AMOUT, NAME