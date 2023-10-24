PGDMP                     	    {            tbase    15.3    15.3 �               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                        0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            !           1262    16399    tbase    DATABASE     y   CREATE DATABASE tbase WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE tbase;
                postgres    false            �            1259    16464 	   condNames    TABLE     n   CREATE TABLE public."condNames" (
    "condNamesId" integer NOT NULL,
    "condName" character varying(45)
);
    DROP TABLE public."condNames";
       public         heap    postgres    false            �            1259    16457    dModels    TABLE     �   CREATE TABLE public."dModels" (
    "dModelsId" integer NOT NULL,
    "dModelName" character varying(45) NOT NULL,
    build integer DEFAULT '-1'::integer
);
    DROP TABLE public."dModels";
       public         heap    postgres    false            �            1259    16419    sns    TABLE     C  CREATE TABLE public.sns (
    "snsId" bigint NOT NULL,
    sn character varying(15) NOT NULL,
    mac character varying(15) DEFAULT ''::character varying,
    dmodel integer DEFAULT 0,
    rev character varying(15) DEFAULT ''::character varying,
    tmodel integer DEFAULT 0,
    name character varying(45) DEFAULT ''::character varying,
    condition integer DEFAULT 1,
    "condDate" date DEFAULT CURRENT_DATE,
    "order" integer DEFAULT '-1'::integer,
    place integer DEFAULT '-1'::integer,
    shiped boolean DEFAULT false,
    "shipedDate" date DEFAULT '2000-01-01'::date,
    "shippedDest" character varying(45) DEFAULT ''::character varying,
    "takenDate" date DEFAULT CURRENT_DATE,
    "takenDoc" character varying(45) DEFAULT ''::character varying,
    "takenOrder" character varying(45) DEFAULT ''::character varying
);
    DROP TABLE public.sns;
       public         heap    postgres    false            �            1259    16860 
   snscomment    TABLE     R   CREATE TABLE public.snscomment (
    "snsId" bigint NOT NULL,
    comment text
);
    DROP TABLE public.snscomment;
       public         heap    postgres    false            �            1259    16410    tModels    TABLE     �   CREATE TABLE public."tModels" (
    "tModelsId" integer NOT NULL,
    "tModelsName" character varying(45) NOT NULL,
    build integer DEFAULT '-1'::integer
);
    DROP TABLE public."tModels";
       public         heap    postgres    false            �            1259    16493    cleanSns    VIEW     �  CREATE VIEW public."cleanSns" AS
 SELECT sns."snsId",
    sns.sn,
    sns.mac,
    "dModels"."dModelName" AS dmodel,
    sns.rev,
    "tModels"."tModelsName" AS tmodel,
    sns.name,
    "condNames"."condName" AS condition,
    sns."condDate",
    sns."order",
    sns.place,
    sns.shiped,
    sns."shipedDate",
    sns."shippedDest",
    sns."takenDate",
    sns."takenDoc",
    sns."takenOrder",
    snscomment.comment
   FROM ((((public.sns
     LEFT JOIN public."dModels" ON (("dModels"."dModelsId" = sns.dmodel)))
     LEFT JOIN public."tModels" ON (("tModels"."tModelsId" = sns.tmodel)))
     LEFT JOIN public."condNames" ON (("condNames"."condNamesId" = sns.condition)))
     LEFT JOIN public.snscomment ON ((snscomment."snsId" = sns."snsId")));
    DROP VIEW public."cleanSns";
       public          postgres    false    217    240    240    221    221    220    220    219    219    219    219    219    219    219    219    219    219    219    219    219    219    219    219    219    217                       1255    16654    qqq()    FUNCTION     m   CREATE FUNCTION public.qqq() RETURNS public."cleanSns"
    LANGUAGE sql
    AS $$SELECT * FROM "cleanSns"$$;
    DROP FUNCTION public.qqq();
       public          postgres    false    222            �            1259    16583    eventTypesNames    TABLE     z   CREATE TABLE public."eventTypesNames" (
    "NamesId" integer NOT NULL,
    "eventName" character varying(45) NOT NULL
);
 %   DROP TABLE public."eventTypesNames";
       public         heap    postgres    false                        1259    17560    matLog    TABLE     �   CREATE TABLE public."matLog" (
    id bigint NOT NULL,
    "matId" integer NOT NULL,
    "eventType" integer NOT NULL,
    "eventText" text,
    "eventTime" timestamp without time zone,
    "user" integer NOT NULL,
    amout integer DEFAULT 0 NOT NULL
);
    DROP TABLE public."matLog";
       public         heap    postgres    false            �            1259    16401    users    TABLE     )  CREATE TABLE public.users (
    userid integer NOT NULL,
    login character varying(45) NOT NULL,
    pass character varying(45) NOT NULL,
    email character varying(45) NOT NULL,
    name character varying(45) NOT NULL,
    access integer NOT NULL,
    token character varying(255) NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false                       1259    17592    CleanMatLog    VIEW     �  CREATE VIEW public."CleanMatLog" AS
 SELECT "matLog".id,
    "matLog"."matId",
    "eventTypesNames"."eventName" AS "eventType",
    "matLog"."eventText",
    "matLog"."eventTime",
    users.name AS "user",
    "matLog".amout
   FROM ((public."matLog"
     LEFT JOIN public."eventTypesNames" ON (("matLog"."eventType" = "eventTypesNames"."NamesId")))
     LEFT JOIN public.users ON (("matLog"."user" = users.userid)));
     DROP VIEW public."CleanMatLog";
       public          postgres    false    215    256    233    233    215    256    256    256    256    256    256            �            1259    16547 
   accesNames    TABLE     v   CREATE TABLE public."accesNames" (
    "accessId" integer NOT NULL,
    "accesName" character varying(45) NOT NULL
);
     DROP TABLE public."accesNames";
       public         heap    postgres    false            �            1259    16546    accesNames_accessId_seq    SEQUENCE     �   CREATE SEQUENCE public."accesNames_accessId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public."accesNames_accessId_seq";
       public          postgres    false    229            "           0    0    accesNames_accessId_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."accesNames_accessId_seq" OWNED BY public."accesNames"."accessId";
          public          postgres    false    228            �            1259    17444    buildMatList    TABLE     b   CREATE TABLE public."buildMatList" (
    "billdId" integer,
    amout integer,
    mat integer
);
 "   DROP TABLE public."buildMatList";
       public         heap    postgres    false            �            1259    17428    builds    TABLE     k   CREATE TABLE public.builds (
    "buildId" integer NOT NULL,
    "dModel" integer,
    "tModel" integer
);
    DROP TABLE public.builds;
       public         heap    postgres    false            �            1259    17427    builds_buildId_seq    SEQUENCE     �   CREATE SEQUENCE public."builds_buildId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."builds_buildId_seq";
       public          postgres    false    245            #           0    0    builds_buildId_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."builds_buildId_seq" OWNED BY public.builds."buildId";
          public          postgres    false    244            �            1259    17458    matsName    TABLE     w   CREATE TABLE public."matsName" (
    "matNameId" integer NOT NULL,
    name character varying(45),
    type integer
);
    DROP TABLE public."matsName";
       public         heap    postgres    false            �            1259    17528    cleanBuildMatList    VIEW     �   CREATE VIEW public."cleanBuildMatList" AS
 SELECT "buildMatList"."billdId",
    "matsName".name AS mat,
    "buildMatList".amout
   FROM (public."buildMatList"
     LEFT JOIN public."matsName" ON (("buildMatList".mat = "matsName"."matNameId")));
 &   DROP VIEW public."cleanBuildMatList";
       public          postgres    false    246    246    246    248    248            �            1259    17532    cleanBuilds    VIEW     G  CREATE VIEW public."cleanBuilds" AS
 SELECT builds."buildId",
    "tModels"."tModelsName" AS "tModel",
    "dModels"."dModelName" AS "dModel"
   FROM ((public.builds
     LEFT JOIN public."tModels" ON ((builds."tModel" = "tModels"."tModelsId")))
     LEFT JOIN public."dModels" ON ((builds."dModel" = "dModels"."dModelsId")));
     DROP VIEW public."cleanBuilds";
       public          postgres    false    217    217    220    220    245    245    245            �            1259    16568 	   deviceLog    TABLE     �   CREATE TABLE public."deviceLog" (
    "logId" bigint NOT NULL,
    "deviceId" bigint NOT NULL,
    "eventType" integer NOT NULL,
    "eventText" text,
    "eventTime" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "user" integer
);
    DROP TABLE public."deviceLog";
       public         heap    postgres    false            �            1259    16628    cleanDeviceLog    VIEW     �  CREATE VIEW public."cleanDeviceLog" AS
 SELECT "deviceLog"."logId",
    "deviceLog"."deviceId",
    "eventTypesNames"."eventName" AS "eventType",
    "deviceLog"."eventText",
    "deviceLog"."eventTime",
    users.name AS "user"
   FROM ((public."deviceLog"
     LEFT JOIN public."eventTypesNames" ON (("eventTypesNames"."NamesId" = "deviceLog"."eventType")))
     LEFT JOIN public.users ON ((users.userid = "deviceLog"."user")));
 #   DROP VIEW public."cleanDeviceLog";
       public          postgres    false    231    233    233    231    231    231    231    231    215    215            �            1259    17090    matTypeNames    TABLE     l   CREATE TABLE public."matTypeNames" (
    "typeId" integer NOT NULL,
    "typeName" character varying(45)
);
 "   DROP TABLE public."matTypeNames";
       public         heap    postgres    false            �            1259    17129    mats    TABLE     �   CREATE TABLE public.mats (
    "matId" integer NOT NULL,
    "1CName" character varying(45),
    amout integer DEFAULT 0,
    "inWork" integer DEFAULT 0,
    name integer,
    price integer DEFAULT '-1'::integer
);
    DROP TABLE public.mats;
       public         heap    postgres    false            �            1259    17496 	   cleanMats    VIEW     s  CREATE VIEW public."cleanMats" AS
 SELECT mats."matId",
    "matsName".name,
    mats."1CName",
    "matTypeNames"."typeName" AS type,
    mats.amout,
    mats."inWork",
    mats.price
   FROM ((public.mats
     LEFT JOIN public."matsName" ON ((mats.name = "matsName"."matNameId")))
     LEFT JOIN public."matTypeNames" ON (("matsName".type = "matTypeNames"."typeId")));
    DROP VIEW public."cleanMats";
       public          postgres    false    241    241    243    243    243    243    243    243    248    248    248            �            1259    16514    orders    TABLE     �  CREATE TABLE public.orders (
    "orderId" bigint NOT NULL,
    meneger integer DEFAULT '-1'::integer,
    "orderDate" date DEFAULT CURRENT_DATE,
    "reqDate" date DEFAULT '2000-01-01'::date,
    "promDate" date DEFAULT '2000-01-01'::date,
    "shDate" date DEFAULT '2000-01-01'::date,
    "isAct" boolean DEFAULT true,
    coment text DEFAULT ''::character varying,
    customer character varying(45) DEFAULT ''::character varying,
    partner character varying(45) DEFAULT ''::character varying,
    disributor character varying(45) DEFAULT ''::character varying,
    name character varying(45) DEFAULT ''::character varying,
    "1СName" integer DEFAULT '-1'::integer
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    16614 
   cleanOrder    VIEW     �  CREATE VIEW public."cleanOrder" AS
 SELECT orders."orderId",
    users.name AS meneger,
    orders."orderDate",
    orders."reqDate",
    orders."promDate",
    orders."shDate",
    orders."isAct",
    orders.coment,
    orders.customer,
    orders.partner,
    orders.disributor,
    orders.name,
    orders."1СName"
   FROM (public.orders
     LEFT JOIN public.users ON ((users.userid = orders.meneger)));
    DROP VIEW public."cleanOrder";
       public          postgres    false    225    225    225    225    225    225    225    225    225    225    225    215    215    225    225            �            1259    16535 	   orderList    TABLE     /  CREATE TABLE public."orderList" (
    "orderListId" bigint NOT NULL,
    "orderId" bigint NOT NULL,
    model integer DEFAULT 1,
    amout integer DEFAULT 0,
    "servType" integer DEFAULT 1,
    "srevActDate" date DEFAULT CURRENT_DATE,
    "lastRed" timestamp without time zone DEFAULT CURRENT_DATE
);
    DROP TABLE public."orderList";
       public         heap    postgres    false            �            1259    16624    cleanOrderList    VIEW     f  CREATE VIEW public."cleanOrderList" AS
 SELECT "orderList"."orderListId",
    "orderList"."orderId",
    "tModels"."tModelsName" AS model,
    "orderList".amout,
    "orderList"."servType",
    "orderList"."srevActDate",
    "orderList"."lastRed"
   FROM (public."orderList"
     LEFT JOIN public."tModels" ON (("tModels"."tModelsId" = "orderList".model)));
 #   DROP VIEW public."cleanOrderList";
       public          postgres    false    217    217    227    227    227    227    227    227    227            �            1259    16636    wearByTModel    VIEW     �   CREATE VIEW public."wearByTModel" AS
 SELECT sns.tmodel,
    sns.name,
    sns.condition,
    count(sns."snsId") AS count,
    sns.shiped
   FROM public.sns
  GROUP BY sns.tmodel, sns.condition, sns.shiped, sns.name
  ORDER BY sns.tmodel, sns.condition;
 !   DROP VIEW public."wearByTModel";
       public          postgres    false    219    219    219    219    219            �            1259    16644    cleanWearByTModel    VIEW     �  CREATE VIEW public."cleanWearByTModel" AS
 SELECT "tModels"."tModelsName" AS tmodel,
    "wearByTModel".name,
    "condNames"."condName" AS condition,
    "wearByTModel".count,
    "wearByTModel".shiped
   FROM ((public."wearByTModel"
     LEFT JOIN public."tModels" ON (("tModels"."tModelsId" = "wearByTModel".tmodel)))
     LEFT JOIN public."condNames" ON (("condNames"."condNamesId" = "wearByTModel".condition)))
  ORDER BY "tModels"."tModelsName", "condNames"."condName";
 &   DROP VIEW public."cleanWearByTModel";
       public          postgres    false    238    217    217    221    221    238    238    238    238            �            1259    16567    deviceLog_logId_seq    SEQUENCE     ~   CREATE SEQUENCE public."deviceLog_logId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."deviceLog_logId_seq";
       public          postgres    false    231            $           0    0    deviceLog_logId_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."deviceLog_logId_seq" OWNED BY public."deviceLog"."logId";
          public          postgres    false    230            �            1259    16582    eventTypesNames_NamesId_seq    SEQUENCE     �   CREATE SEQUENCE public."eventTypesNames_NamesId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."eventTypesNames_NamesId_seq";
       public          postgres    false    233            %           0    0    eventTypesNames_NamesId_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."eventTypesNames_NamesId_seq" OWNED BY public."eventTypesNames"."NamesId";
          public          postgres    false    232            �            1259    17559    matLog_id_seq    SEQUENCE     x   CREATE SEQUENCE public."matLog_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public."matLog_id_seq";
       public          postgres    false    256            &           0    0    matLog_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public."matLog_id_seq" OWNED BY public."matLog".id;
          public          postgres    false    255            �            1259    17542 	   matplaces    TABLE     F   CREATE TABLE public.matplaces (
    mat integer,
    place integer
);
    DROP TABLE public.matplaces;
       public         heap    postgres    false            �            1259    17504    matsBy1C    VIEW     �   CREATE VIEW public."matsBy1C" AS
 SELECT mats."1CName",
    sum(mats.amout) AS sum
   FROM public.mats
  GROUP BY mats."1CName";
    DROP VIEW public."matsBy1C";
       public          postgres    false    243    243            �            1259    17500 
   matsByName    VIEW     �   CREATE VIEW public."matsByName" AS
 SELECT "matsName".name,
    sum(mats.amout) AS sum
   FROM (public.mats
     LEFT JOIN public."matsName" ON ((mats.name = "matsName"."matNameId")))
  GROUP BY "matsName".name;
    DROP VIEW public."matsByName";
       public          postgres    false    248    248    243    243            �            1259    17457    matsName_matNameId_seq    SEQUENCE     �   CREATE SEQUENCE public."matsName_matNameId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."matsName_matNameId_seq";
       public          postgres    false    248            '           0    0    matsName_matNameId_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."matsName_matNameId_seq" OWNED BY public."matsName"."matNameId";
          public          postgres    false    247            �            1259    17128    mats_matId_seq    SEQUENCE     �   CREATE SEQUENCE public."mats_matId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."mats_matId_seq";
       public          postgres    false    243            (           0    0    mats_matId_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."mats_matId_seq" OWNED BY public.mats."matId";
          public          postgres    false    242            �            1259    16534    orderList_orderListId_seq    SEQUENCE     �   CREATE SEQUENCE public."orderList_orderListId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."orderList_orderListId_seq";
       public          postgres    false    227            )           0    0    orderList_orderListId_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."orderList_orderListId_seq" OWNED BY public."orderList"."orderListId";
          public          postgres    false    226            �            1259    16513    orders_orderId_seq    SEQUENCE     }   CREATE SEQUENCE public."orders_orderId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."orders_orderId_seq";
       public          postgres    false    225            *           0    0    orders_orderId_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."orders_orderId_seq" OWNED BY public.orders."orderId";
          public          postgres    false    224            �            1259    16418    sns_snsId_seq    SEQUENCE     x   CREATE SEQUENCE public."sns_snsId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public."sns_snsId_seq";
       public          postgres    false    219            +           0    0    sns_snsId_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public."sns_snsId_seq" OWNED BY public.sns."snsId";
          public          postgres    false    218            �            1259    16409    tModels_tModelsId_seq    SEQUENCE     �   CREATE SEQUENCE public."tModels_tModelsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."tModels_tModelsId_seq";
       public          postgres    false    217            ,           0    0    tModels_tModelsId_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."tModels_tModelsId_seq" OWNED BY public."tModels"."tModelsId";
          public          postgres    false    216            �            1259    16400    users_userid_seq    SEQUENCE     �   CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.users_userid_seq;
       public          postgres    false    215            -           0    0    users_userid_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;
          public          postgres    false    214            �            1259    16632    wear    VIEW     P  CREATE VIEW public.wear AS
 SELECT sns."order",
    sns.name,
    count(sns."snsId") AS count,
    orders.name AS "orderName"
   FROM (public.sns
     LEFT JOIN public.orders ON ((orders."orderId" = sns."order")))
  WHERE (sns.shiped = false)
  GROUP BY sns."order", sns.name, orders.name
  ORDER BY sns."order", sns.name, orders.name;
    DROP VIEW public.wear;
       public          postgres    false    225    225    219    219    219    219            �            1259    16509    wearByPlace    VIEW     �   CREATE VIEW public."wearByPlace" AS
 SELECT sns.place,
    sns.name,
    count(sns."snsId") AS count
   FROM public.sns
  WHERE (sns.shiped = false)
  GROUP BY sns.place, sns.name
  ORDER BY sns.place, sns.name;
     DROP VIEW public."wearByPlace";
       public          postgres    false    219    219    219    219                       2604    16550    accesNames accessId    DEFAULT     �   ALTER TABLE ONLY public."accesNames" ALTER COLUMN "accessId" SET DEFAULT nextval('public."accesNames_accessId_seq"'::regclass);
 F   ALTER TABLE public."accesNames" ALTER COLUMN "accessId" DROP DEFAULT;
       public          postgres    false    228    229    229                       2604    17431    builds buildId    DEFAULT     t   ALTER TABLE ONLY public.builds ALTER COLUMN "buildId" SET DEFAULT nextval('public."builds_buildId_seq"'::regclass);
 ?   ALTER TABLE public.builds ALTER COLUMN "buildId" DROP DEFAULT;
       public          postgres    false    245    244    245                       2604    16571    deviceLog logId    DEFAULT     x   ALTER TABLE ONLY public."deviceLog" ALTER COLUMN "logId" SET DEFAULT nextval('public."deviceLog_logId_seq"'::regclass);
 B   ALTER TABLE public."deviceLog" ALTER COLUMN "logId" DROP DEFAULT;
       public          postgres    false    230    231    231                       2604    16586    eventTypesNames NamesId    DEFAULT     �   ALTER TABLE ONLY public."eventTypesNames" ALTER COLUMN "NamesId" SET DEFAULT nextval('public."eventTypesNames_NamesId_seq"'::regclass);
 J   ALTER TABLE public."eventTypesNames" ALTER COLUMN "NamesId" DROP DEFAULT;
       public          postgres    false    233    232    233                       2604    17563 	   matLog id    DEFAULT     j   ALTER TABLE ONLY public."matLog" ALTER COLUMN id SET DEFAULT nextval('public."matLog_id_seq"'::regclass);
 :   ALTER TABLE public."matLog" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    256    255    256                       2604    17132 
   mats matId    DEFAULT     l   ALTER TABLE ONLY public.mats ALTER COLUMN "matId" SET DEFAULT nextval('public."mats_matId_seq"'::regclass);
 ;   ALTER TABLE public.mats ALTER COLUMN "matId" DROP DEFAULT;
       public          postgres    false    242    243    243                       2604    17461    matsName matNameId    DEFAULT     ~   ALTER TABLE ONLY public."matsName" ALTER COLUMN "matNameId" SET DEFAULT nextval('public."matsName_matNameId_seq"'::regclass);
 E   ALTER TABLE public."matsName" ALTER COLUMN "matNameId" DROP DEFAULT;
       public          postgres    false    248    247    248                       2604    16538    orderList orderListId    DEFAULT     �   ALTER TABLE ONLY public."orderList" ALTER COLUMN "orderListId" SET DEFAULT nextval('public."orderList_orderListId_seq"'::regclass);
 H   ALTER TABLE public."orderList" ALTER COLUMN "orderListId" DROP DEFAULT;
       public          postgres    false    226    227    227                       2604    16517    orders orderId    DEFAULT     t   ALTER TABLE ONLY public.orders ALTER COLUMN "orderId" SET DEFAULT nextval('public."orders_orderId_seq"'::regclass);
 ?   ALTER TABLE public.orders ALTER COLUMN "orderId" DROP DEFAULT;
       public          postgres    false    224    225    225            �           2604    16498 	   sns snsId    DEFAULT     j   ALTER TABLE ONLY public.sns ALTER COLUMN "snsId" SET DEFAULT nextval('public."sns_snsId_seq"'::regclass);
 :   ALTER TABLE public.sns ALTER COLUMN "snsId" DROP DEFAULT;
       public          postgres    false    219    218    219            �           2604    16499    tModels tModelsId    DEFAULT     |   ALTER TABLE ONLY public."tModels" ALTER COLUMN "tModelsId" SET DEFAULT nextval('public."tModels_tModelsId_seq"'::regclass);
 D   ALTER TABLE public."tModels" ALTER COLUMN "tModelsId" DROP DEFAULT;
       public          postgres    false    217    216    217            �           2604    16500    users userid    DEFAULT     l   ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);
 ;   ALTER TABLE public.users ALTER COLUMN userid DROP DEFAULT;
       public          postgres    false    215    214    215                      0    16547 
   accesNames 
   TABLE DATA           ?   COPY public."accesNames" ("accessId", "accesName") FROM stdin;
    public          postgres    false    229   p�                 0    17444    buildMatList 
   TABLE DATA           ?   COPY public."buildMatList" ("billdId", amout, mat) FROM stdin;
    public          postgres    false    246   ��                 0    17428    builds 
   TABLE DATA           ?   COPY public.builds ("buildId", "dModel", "tModel") FROM stdin;
    public          postgres    false    245   �                 0    16464 	   condNames 
   TABLE DATA           @   COPY public."condNames" ("condNamesId", "condName") FROM stdin;
    public          postgres    false    221   K�                 0    16457    dModels 
   TABLE DATA           E   COPY public."dModels" ("dModelsId", "dModelName", build) FROM stdin;
    public          postgres    false    220   ��                 0    16568 	   deviceLog 
   TABLE DATA           i   COPY public."deviceLog" ("logId", "deviceId", "eventType", "eventText", "eventTime", "user") FROM stdin;
    public          postgres    false    231   ��                 0    16583    eventTypesNames 
   TABLE DATA           C   COPY public."eventTypesNames" ("NamesId", "eventName") FROM stdin;
    public          postgres    false    233   �                0    17560    matLog 
   TABLE DATA           e   COPY public."matLog" (id, "matId", "eventType", "eventText", "eventTime", "user", amout) FROM stdin;
    public          postgres    false    256   ��                0    17090    matTypeNames 
   TABLE DATA           >   COPY public."matTypeNames" ("typeId", "typeName") FROM stdin;
    public          postgres    false    241   ��                0    17542 	   matplaces 
   TABLE DATA           /   COPY public.matplaces (mat, place) FROM stdin;
    public          postgres    false    254   8�                0    17129    mats 
   TABLE DATA           O   COPY public.mats ("matId", "1CName", amout, "inWork", name, price) FROM stdin;
    public          postgres    false    243   �                0    17458    matsName 
   TABLE DATA           =   COPY public."matsName" ("matNameId", name, type) FROM stdin;
    public          postgres    false    248   ��      	          0    16535 	   orderList 
   TABLE DATA           s   COPY public."orderList" ("orderListId", "orderId", model, amout, "servType", "srevActDate", "lastRed") FROM stdin;
    public          postgres    false    227   u�                0    16514    orders 
   TABLE DATA           �   COPY public.orders ("orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName") FROM stdin;
    public          postgres    false    225   	�                0    16419    sns 
   TABLE DATA           �   COPY public.sns ("snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder") FROM stdin;
    public          postgres    false    219   <�                0    16860 
   snscomment 
   TABLE DATA           6   COPY public.snscomment ("snsId", comment) FROM stdin;
    public          postgres    false    240   �                0    16410    tModels 
   TABLE DATA           F   COPY public."tModels" ("tModelsId", "tModelsName", build) FROM stdin;
    public          postgres    false    217   Ù      �          0    16401    users 
   TABLE DATA           P   COPY public.users (userid, login, pass, email, name, access, token) FROM stdin;
    public          postgres    false    215   �      .           0    0    accesNames_accessId_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."accesNames_accessId_seq"', 1, false);
          public          postgres    false    228            /           0    0    builds_buildId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."builds_buildId_seq"', 1, false);
          public          postgres    false    244            0           0    0    deviceLog_logId_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."deviceLog_logId_seq"', 1126, true);
          public          postgres    false    230            1           0    0    eventTypesNames_NamesId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."eventTypesNames_NamesId_seq"', 1, false);
          public          postgres    false    232            2           0    0    matLog_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public."matLog_id_seq"', 15, true);
          public          postgres    false    255            3           0    0    matsName_matNameId_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."matsName_matNameId_seq"', 9, true);
          public          postgres    false    247            4           0    0    mats_matId_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."mats_matId_seq"', 19, true);
          public          postgres    false    242            5           0    0    orderList_orderListId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."orderList_orderListId_seq"', 5, true);
          public          postgres    false    226            6           0    0    orders_orderId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."orders_orderId_seq"', 50, true);
          public          postgres    false    224            7           0    0    sns_snsId_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."sns_snsId_seq"', 6956, true);
          public          postgres    false    218            8           0    0    tModels_tModelsId_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."tModels_tModelsId_seq"', 3, true);
          public          postgres    false    216            9           0    0    users_userid_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.users_userid_seq', 3, true);
          public          postgres    false    214            7           2606    16552    accesNames accesNames_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."accesNames"
    ADD CONSTRAINT "accesNames_pkey" PRIMARY KEY ("accessId");
 H   ALTER TABLE ONLY public."accesNames" DROP CONSTRAINT "accesNames_pkey";
       public            postgres    false    229            E           2606    17433    builds builds_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.builds
    ADD CONSTRAINT builds_pkey PRIMARY KEY ("buildId");
 <   ALTER TABLE ONLY public.builds DROP CONSTRAINT builds_pkey;
       public            postgres    false    245            1           2606    16468    condNames condNames_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."condNames"
    ADD CONSTRAINT "condNames_pkey" PRIMARY KEY ("condNamesId");
 F   ALTER TABLE ONLY public."condNames" DROP CONSTRAINT "condNames_pkey";
       public            postgres    false    221            -           2606    16461    dModels dModels_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."dModels"
    ADD CONSTRAINT "dModels_pkey" PRIMARY KEY ("dModelsId");
 B   ALTER TABLE ONLY public."dModels" DROP CONSTRAINT "dModels_pkey";
       public            postgres    false    220            /           2606    16463    dModels dModels_unic 
   CONSTRAINT     [   ALTER TABLE ONLY public."dModels"
    ADD CONSTRAINT "dModels_unic" UNIQUE ("dModelName");
 B   ALTER TABLE ONLY public."dModels" DROP CONSTRAINT "dModels_unic";
       public            postgres    false    220            9           2606    16575    deviceLog deviceLog_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_pkey" PRIMARY KEY ("logId");
 F   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_pkey";
       public            postgres    false    231            ;           2606    16588 $   eventTypesNames eventTypesNames_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."eventTypesNames"
    ADD CONSTRAINT "eventTypesNames_pkey" PRIMARY KEY ("NamesId");
 R   ALTER TABLE ONLY public."eventTypesNames" DROP CONSTRAINT "eventTypesNames_pkey";
       public            postgres    false    233            !           2606    16408    users login_unic 
   CONSTRAINT     L   ALTER TABLE ONLY public.users
    ADD CONSTRAINT login_unic UNIQUE (login);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT login_unic;
       public            postgres    false    215            K           2606    17568    matLog matLog_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public."matLog"
    ADD CONSTRAINT "matLog_pkey" PRIMARY KEY (id);
 @   ALTER TABLE ONLY public."matLog" DROP CONSTRAINT "matLog_pkey";
       public            postgres    false    256            ?           2606    17094    matTypeNames matTypeNames_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public."matTypeNames"
    ADD CONSTRAINT "matTypeNames_pkey" PRIMARY KEY ("typeId");
 L   ALTER TABLE ONLY public."matTypeNames" DROP CONSTRAINT "matTypeNames_pkey";
       public            postgres    false    241            I           2606    17551 !   matplaces matplaces_mat_place_key 
   CONSTRAINT     b   ALTER TABLE ONLY public.matplaces
    ADD CONSTRAINT matplaces_mat_place_key UNIQUE (mat, place);
 K   ALTER TABLE ONLY public.matplaces DROP CONSTRAINT matplaces_mat_place_key;
       public            postgres    false    254    254            G           2606    17463    matsName matsName_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."matsName"
    ADD CONSTRAINT "matsName_pkey" PRIMARY KEY ("matNameId");
 D   ALTER TABLE ONLY public."matsName" DROP CONSTRAINT "matsName_pkey";
       public            postgres    false    248            A           2606    17483    mats mats_1CName_name_prise_key 
   CONSTRAINT     m   ALTER TABLE ONLY public.mats
    ADD CONSTRAINT "mats_1CName_name_prise_key" UNIQUE ("1CName", name, price);
 K   ALTER TABLE ONLY public.mats DROP CONSTRAINT "mats_1CName_name_prise_key";
       public            postgres    false    243    243    243            C           2606    17134    mats mats_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.mats
    ADD CONSTRAINT mats_pkey PRIMARY KEY ("matId");
 8   ALTER TABLE ONLY public.mats DROP CONSTRAINT mats_pkey;
       public            postgres    false    243            5           2606    16540    orderList orderList_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_pkey" PRIMARY KEY ("orderListId");
 F   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_pkey";
       public            postgres    false    227            3           2606    16523    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY ("orderId");
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    225            )           2606    16874    sns sn 
   CONSTRAINT     ?   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sn UNIQUE (sn);
 0   ALTER TABLE ONLY public.sns DROP CONSTRAINT sn;
       public            postgres    false    219            +           2606    16430    sns sns_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_pkey PRIMARY KEY ("snsId");
 6   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_pkey;
       public            postgres    false    219            =           2606    16866    snscomment snscomment_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.snscomment
    ADD CONSTRAINT snscomment_pkey PRIMARY KEY ("snsId");
 D   ALTER TABLE ONLY public.snscomment DROP CONSTRAINT snscomment_pkey;
       public            postgres    false    240            %           2606    16415    tModels tModels_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."tModels"
    ADD CONSTRAINT "tModels_pkey" PRIMARY KEY ("tModelsId");
 B   ALTER TABLE ONLY public."tModels" DROP CONSTRAINT "tModels_pkey";
       public            postgres    false    217            '           2606    16417    tModels tModels_tModelsName_key 
   CONSTRAINT     g   ALTER TABLE ONLY public."tModels"
    ADD CONSTRAINT "tModels_tModelsName_key" UNIQUE ("tModelsName");
 M   ALTER TABLE ONLY public."tModels" DROP CONSTRAINT "tModels_tModelsName_key";
       public            postgres    false    217            #           2606    16406    users users_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    215            \           2606    17508 "   buildMatList buildMatList_mat_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."buildMatList"
    ADD CONSTRAINT "buildMatList_mat_fkey" FOREIGN KEY (mat) REFERENCES public."matsName"("matNameId") NOT VALID;
 P   ALTER TABLE ONLY public."buildMatList" DROP CONSTRAINT "buildMatList_mat_fkey";
       public          postgres    false    3399    248    246            Z           2606    17434    builds builds_dModel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.builds
    ADD CONSTRAINT "builds_dModel_fkey" FOREIGN KEY ("dModel") REFERENCES public."dModels"("dModelsId");
 E   ALTER TABLE ONLY public.builds DROP CONSTRAINT "builds_dModel_fkey";
       public          postgres    false    220    3373    245            [           2606    17439    builds builds_tModel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.builds
    ADD CONSTRAINT "builds_tModel_fkey" FOREIGN KEY ("tModel") REFERENCES public."tModels"("tModelsId");
 E   ALTER TABLE ONLY public.builds DROP CONSTRAINT "builds_tModel_fkey";
       public          postgres    false    217    3365    245            R           2606    17552    dModels dModels_build_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."dModels"
    ADD CONSTRAINT "dModels_build_fkey" FOREIGN KEY (build) REFERENCES public.builds("buildId") NOT VALID;
 H   ALTER TABLE ONLY public."dModels" DROP CONSTRAINT "dModels_build_fkey";
       public          postgres    false    220    3397    245            V           2606    16576 !   deviceLog deviceLog_deviceId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES public.sns("snsId");
 O   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_deviceId_fkey";
       public          postgres    false    219    3371    231            W           2606    16589 "   deviceLog deviceLog_eventType_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_eventType_fkey" FOREIGN KEY ("eventType") REFERENCES public."eventTypesNames"("NamesId") NOT VALID;
 P   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_eventType_fkey";
       public          postgres    false    233    3387    231            X           2606    16594    deviceLog deviceLog_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_user_fkey" FOREIGN KEY ("user") REFERENCES public.users(userid) NOT VALID;
 K   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_user_fkey";
       public          postgres    false    3363    215    231            _           2606    17574    matLog matLog_eventType_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."matLog"
    ADD CONSTRAINT "matLog_eventType_fkey" FOREIGN KEY ("eventType") REFERENCES public."eventTypesNames"("NamesId") NOT VALID;
 J   ALTER TABLE ONLY public."matLog" DROP CONSTRAINT "matLog_eventType_fkey";
       public          postgres    false    233    3387    256            `           2606    17569    matLog matLog_matId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."matLog"
    ADD CONSTRAINT "matLog_matId_fkey" FOREIGN KEY ("matId") REFERENCES public.mats("matId") NOT VALID;
 F   ALTER TABLE ONLY public."matLog" DROP CONSTRAINT "matLog_matId_fkey";
       public          postgres    false    243    3395    256            a           2606    17579    matLog matLog_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."matLog"
    ADD CONSTRAINT "matLog_user_fkey" FOREIGN KEY ("user") REFERENCES public.users(userid) NOT VALID;
 E   ALTER TABLE ONLY public."matLog" DROP CONSTRAINT "matLog_user_fkey";
       public          postgres    false    215    3363    256            ^           2606    17545    matplaces matplaces_mat_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matplaces
    ADD CONSTRAINT matplaces_mat_fkey FOREIGN KEY (mat) REFERENCES public.mats("matId") NOT VALID;
 F   ALTER TABLE ONLY public.matplaces DROP CONSTRAINT matplaces_mat_fkey;
       public          postgres    false    254    3395    243            ]           2606    17474    matsName matsName_type_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."matsName"
    ADD CONSTRAINT "matsName_type_fkey" FOREIGN KEY (type) REFERENCES public."matTypeNames"("typeId") NOT VALID;
 I   ALTER TABLE ONLY public."matsName" DROP CONSTRAINT "matsName_type_fkey";
       public          postgres    false    248    3391    241            Y           2606    17469    mats mats_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mats
    ADD CONSTRAINT mats_name_fkey FOREIGN KEY (name) REFERENCES public."matsName"("matNameId") NOT VALID;
 =   ALTER TABLE ONLY public.mats DROP CONSTRAINT mats_name_fkey;
       public          postgres    false    3399    248    243            T           2606    16619    orderList orderList_model_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_model_fkey" FOREIGN KEY (model) REFERENCES public."tModels"("tModelsId") NOT VALID;
 L   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_model_fkey";
       public          postgres    false    3365    227    217            U           2606    16541     orderList orderList_orderId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public.orders("orderId");
 N   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_orderId_fkey";
       public          postgres    false    3379    225    227            S           2606    16524    orders orders_meneger_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_meneger_fkey FOREIGN KEY (meneger) REFERENCES public.users(userid) NOT VALID;
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_meneger_fkey;
       public          postgres    false    225    215    3363            N           2606    16474    sns sns_condition_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_condition_fkey FOREIGN KEY (condition) REFERENCES public."condNames"("condNamesId") NOT VALID;
 @   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_condition_fkey;
       public          postgres    false    3377    219    221            O           2606    16469    sns sns_dmodel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_dmodel_fkey FOREIGN KEY (dmodel) REFERENCES public."dModels"("dModelsId") NOT VALID;
 =   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_dmodel_fkey;
       public          postgres    false    220    219    3373            P           2606    16529    sns sns_order_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_order_fkey FOREIGN KEY ("order") REFERENCES public.orders("orderId") NOT VALID;
 <   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_order_fkey;
       public          postgres    false    219    225    3379            Q           2606    16431    sns sns_tmodel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_tmodel_fkey FOREIGN KEY (tmodel) REFERENCES public."tModels"("tModelsId") NOT VALID;
 =   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_tmodel_fkey;
       public          postgres    false    219    3365    217            M           2606    17536    tModels tModels_build_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."tModels"
    ADD CONSTRAINT "tModels_build_fkey" FOREIGN KEY (build) REFERENCES public.builds("buildId") NOT VALID;
 H   ALTER TABLE ONLY public."tModels" DROP CONSTRAINT "tModels_build_fkey";
       public          postgres    false    245    3397    217            L           2606    16553    users users_access_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_access_fkey FOREIGN KEY (access) REFERENCES public."accesNames"("accessId") NOT VALID;
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_access_fkey;
       public          postgres    false    229    3383    215               O   x�3�tL����2�0�bÅ}v\�~a��r��b��e�ya�]v_�pa�1�9�^��[.l���bW� �*(�         6   x�ɱ  ��:��`��s *�22R�X�p�s�N�k���{��	7         &   x�3�4��43�2�43�4��2�Һ���\1z\\\ _��         ;   x�3�0I�bÅ6^�w���V.C�/컰,���>.#�s/lU�؈"���� ��#}         2  x�e�]r�6 ���*���G�ɦ��3N�j:{�=R�T� )�y�G$(�����m] �-��?�8���ݼ�۝Ì-4������S%:�\%<E=V��Z�l���c����38���� ��J�o|~�K뢣e[��j0J���X����%c���V�n�V1�7F�G�џҬm!�'楠..�qB�1Ls�lU�7Qr���A�ȭ??R%��Yk� oPF�}�(���Ē#[�7,J�w߽W�{��U��ZnO�/��9A0$	����Q��C�!Z&�swt��q���s��l��Pߎ�F��2S4�s$m�Y���+�j-�4Egxm��5������M�K�1j牒��5?Zhr����	�s(j��dm�""���m^
�����'N=��i�s�X��kO��Ĝ$�Ĝ$��G[w&k=��X��%�*1 oHN�z�<�$.s��4������X�p��Qkyi���R����(-l�Z�6���J���ܔ����S;�����5#��/?�68?�*�?�����烓�%k~��bY�����U���N�Z+��K��&�f�Mj�ܛ�����\�����)h�wD�!��X�M`�����.��;��7��J֍�`�w��b��b ��K"c� �B#���eٿ�����/�i7��(s�zn��7�����e����Mb� tH��@�,�{H���{����n�����(K'��|�3���@?0u����V#ˁcd�*|���� 
`�^�w�u{9��ȑF�, 9�U���P�'Hh�S�������#N=��H��OK�U�0���<�U!rq��zG~�7�Y6���w��?4 9c�����ɘH�TF�H	|�R��+���HcWQp�_��t��|�f.�sӡM$��YW~�3i�0߭^R4IRg�n��L|k�d��f�$7L.F��p=�o�%o����� y�y�� ��٢�>[��lR[��-F9:�U֋��(�d4�z�}��5�������G�����ui���A��������?�P�            x�����5�q�7^��=��<g��{��v�����q�4`XB��:P44�IH�y�#��֗Y��,C�6E)��V՛�8d�v������������?�����������������7~����/n��vw�-�^�%ܼ���o��������0�����������?�Y��K��*�|b�ԭ|�Zu��Ԫ�*I�*��O�`%}u�V.H���OX=��K��Å�I����.����
�ت�
�p�Q1R��pR�m�Wn���&�^�ؤ߫�6�߫A��ͷ�7/�Z���mм!���-�7�V	�*D��>Ub+hË���(TTڠ�(TTڠ�&~B�A��/������+Q´�p�$Gk�p�$G��{a�M�����&�]V�Q�iC�6hMν��6ⷁ5���V��TQ~�J��w�T~hx������7wd����7�Ѝ~��ތb7��7�f������(w�R��Q�F?$�7�zKY��Z7��������q�f����P�ͷoF�w����8��&aZ�>Mf7�
��?�V���B���j�U�=��*�'����
V�}.�Uc�Nf�6�%�V��V��gYhx�*����Z%�%�V�wwB��;I�U�]�Ъ�Yf���q��c�Nh���Z��
�"{OB���&���
�
{�B��ޮЪ�g-���
�Dh�x�&��'Z�
�"�u�V���B��{x�UaAhU�7Z5��dVuc�Kh�8Z+���
�{�B��~��*��,�ʴ��a�r��ݳC��&�Q%/Hh�h/3jyAB#G���ȓC#4
�1�"yAB#v҄F���Q!RhTo}����_���ן=�����_�����������/�_=~����|����}�I����7���{�����j��b#ht8rK���v�n�6���m<m����c��Q���������<��_<���~��g�6=����֛Ni�n��x
�>�9
�jl�סP�ƶ?o=s�w�a�g/x���{��6�Z�ޝm�>*m��hm��]�l�o-]�l����Q
[D)�{�6�{Hl۟���y��7W�s���M��#����_?��񧏟?�r)��ru�4#����� I6H�h~���_�w��>��=������?������o��3�q����飏�C�OQ����<͖KP��T��F{*�x�� �i/A�KP��%�FS�
T�M�*w�����TW{�g'Ă��p�`�1bG*�؍����h�����h�񗵿��/g�1vS���h�`|v�>'�k�.^Gc���N�h�a�}l(,k;�/��T����;�c�wN��Va|vst4Ɔ];$3)���h��;h�2���1��9cS�f�aZyf�aAk�9,('��%�<s�U�W�z��e�۾s������M���`?��e�U�L�����`�}1؇����>��_����f����[�K���������,h����b�P�w�e���������5' ݏE��xC����ݷ��l�}F/��>�B�~A.�y�����  ��4 ��p ����8 B� �����C���c�}!�^��=���Q�VI�:���Q��U�C�{b���y-a9vĖ�<�eKX�ݴ%��^�Vb'n	+�O��U��[ª��-a5v W�(����F��k#!G�goq	+�y	+�#����/]���.a�Z��*;�KX�=�,��������\���.av,��"�������B2�}�ٸݵ�!��1r���G�.孝����v]>�8#5��!�6�o��˦|ۡ�Ϲ����q���>v�w־m(,)�s�
��S�iɘ�[`c$�����I�t�m�����w>;��A�=�φ���gEr4�0>+��q§:
?g�e�wFʣ�1v���h�����A�0�<jP*)��
Cʣ�vP��PXP�Q���D8��H�i�>6�a�iq���
��v6;�=Uѕ{ll�_X;;�����f�ތ+�O~�7����h\6�|�o�}H��|ll����L�f`�|���n��7'+E�,�vv+�f���{�W�e��(PX;9�+vv�f��uތ=&姢�|V��;��X��iS���9�lI1��
��Ú�/CaE��V��lP��ғ7c(�*GU����Cagތ���3oƤ0�cCaE�������8P'I2�m��j�+u��d
� 8f'I�prF��y��$���yI����5�t� ��^���z���7 ��%��(H��W�X P�$���%��7 �(I���bL8~M_�+1&A��� `y]���4��Go�	�ݏ��Q��Е�A����'0gRFgL������D�%){�-�sb5<j�B5�@���	0'6 sb3�D�B3	�PRF�+T�hD�+T����T�)��n)P�j��ѥ�5w�!Q��b��|)P��jL�FRT��9�"$(QRvP��b@�� $�S
���,m�U�Y X�-�1��l�
�O4(y�h٭#M-��3E�Ӆ�~��'�9��и&J�t� �O4	������cA��Kb��feD�3	�����#�q3&D�c0�D���fP"��1Z X��Aʈ=�� �BJ4̉�5������ �JJ4H��o7���O3H���Xv�ԟ�>#2�1X^")�����0����0�U:F�O@��c���l��8�ψb�c��c��RF�4ì�D|%"��A�ȱĠWbC�%:�WhȱĠWb�H���ؐc���Xo (Qr �@�D�r,��ؐcA�=�"�z%��Vg�;p4'����' 8~A�һg��<�u�1VeY�v2�
�'�3��uƅÿ:�ʡ_�q㰯���p��ћ��p���s�Wg8̫3���'��3�vuƅú:��e�q�p�ʘ�"J�PNDV�3{���ouƑC�:��a[�q搭θp�Vg\9T�3n�US��챁7c��Y����q�r�q�R�q�2�q��q���q���q��1�1�v�z3v\��3�\��3\��3�\��3N\��3�\��3.\��3�\��3n\��2����7Sn�+�!l;��F^oƁ�otƑKotƉ�ntƙKntƅ�mtƕKmtƍ�lTƔw�n+(��VP�A��\�v&�<�v+�S�:���B�q�T�θr�Pg�8E�2�|�S�a�jG��6���sX��GN��uƙӀ:��)@�q���θq�OeL��6�<)G ;75{N����tƑ�|:��)>�q���θpjOg\9+�3n��S������q���L���sNg8�3��}�'μ�3g�tƅ3n:���6�q�L�ʘ��g�c�;ΰ�=g�tƁ3k:��Y5�q⌚�8s6Mg\8��3��E�7Π���L�Rat�l��7c�Y3�q�����_�vw�Չy+���x���y�������*�:KXO/u+<��KX�]�%,�Cl	+p<a	�RY�J�Y���Y�z�.KX�=�%�g��
V�8걄�ا_��\X�
SZbZ�J�]��P^�z��\�z�\�z��\��D�"ݧg����]�V���V��Vb�b	+����U�I\ª�.a5v�W�(�׌G�mk�ZY3����"V�X�Vb�e	+�߶�U��]ª�/a=klW��3���8����9���8*��9<���8����9½�U8C���LU,a=�e�Y��bu�*�%,ǅ�KX��*����������W�.ae�t^�*\���U��z	�qz`�xk��g���<猖��/aE��^�J\d����"x	�p1�ֳ5�V����cEK޽۞'ї�<-aΊ-aEN�,a=�
/ae�S^�*\0��U��{	�q��
5�3��&���%��р%���2���mk���X��\���U�h~	��%��GdV��X�)0��C/ay��^�zV�/aE.�_�J\鿄���	�p)�V�#KX�O��`�a��F_�o�ͭ�֌������ȩ�������&�#%f�M�)�;�
�3�g��=�    *_/����:�,t�p����r|=�������<���v�%��E^KX�K��
߻��U��%��wZ�`��`KX��T[��|��V��ǖ�"_F�����I�B��pGN��W�,a=/�Yª|��V�+�V��I��c0{��+���<_����ƪ%��7~-a%��m	+�EyKX���[ª|�V��V�����%,�wt-a���ѳ����+�&["����� ���~��6���'B5�����~��טw��yjYcM	V�5��Zk>o��v�oIq���^�͏�A�ю�P�?�ޏ椸�6Ϣ�v�."������l�8����d��Ir�����sB�=~���������>Y~��M���ȿy���_�Ct�o�ǹ�lBDX�H��o���B(�`����S-`	���{� Ik|y��ߞ7*.aQn�Ӹ_��R�5��3��s!_��|��V�q7m�בUy[�j��`�%w՞�9�/�KX�W�%����V�K����7�.ae�?w	��KXt}��㮦�H_�n���#����KX��2^�
|��V䋎��H�k�/����%����.a=/U]�j|��
V����%,�w�.aQ$�cG��?�x���;�͡n��븖5��o����{�Ɯ�Am�v����ʧ����lR?9����m�m���#T[S���:!�r^n��H����`��0:��G���9���ѻ���Ѽ��|�`N�����ȵ�M��)����Ȩm��l��	L�Ó���:��Cu���~4�H ��<r���dq0G�k�d�����Hn9�����z�_�ԭ��#k�������,�Gs�N�<���ίoG�ͫ�P<K�.5�\�[:[=maӑ��Wng�,����5G6��C6Gv��b�#�\�E,rq}G��.z_��(]������}Q�K{�����%,av��"�NKX�ݸ%��N�Y��+!֠肈%(:!�t�(GN��'�p	*���y+���ؙZ���Y-av���*�\KX�������v�8��fKX���%��N�Vdn	+��t	+�o��U86��U��[�j��`����%,����gOq	+�۸�ه\�J�P.ae�.��
��KX�`�V>󥊿~�3����m�t'�˿�ѿ����/�������Gpo��'_��_~���;�������	���v�_@ ��_���v���{�m��� }������/���׏�{�������B���_C�����>�~��]θ��}��+z��_���������ۯ?������=y��Hs�o֘��K����(U(��x����~�J.}�c��ki� p���V�7 %7,�0$W���-xɍ�H��e@@�'@��iW)��
ǀv���j@�ntX���������a��Fg���t���z@�ѩz=��舿 %:�#�(���H]�p�� R�x>� ]�豣@�� �%:��4 P����7 ��RN]��"�To\��@���y�q���nԐJ�7�S���x�
05 ݸ�K�J��i=��9��jn7.��
�c��Wp�Pb0(�@����%���,_��h�A!%�\�D�Fs �D�V�P����+��>c�7ÄR����*�h�#UR�AH8'�7�|P�Dg@���~�-[�%Z6YJ���РDgPb�9��7��sb��a0��Pb�� J��w7(1�?#Z]s� %f��Ѹ���� (1�u�!�be= J�z%�B*Y�H��� %F�WpPbԏ\&�u�j �c�ќ��p��0�Pb2|FGs�aBq4'���d���J�4'��xC	��p�$5 Q�O@�2�v���S��O4�θM�������Ν�� R��3(1[~E�/1@��F�-K[ %Z P�eZ��e@9��F9��r,��(�R,O %6��(�R, (��uʱ��F9�bX(�R- (���u�RH��ш���'��AH�c�!Q����9 J����r,��+@��Tn��v5j ��c9gH��Ls�a8gR��	��f�2�X6���c�&Rj ��fPb�}�A�ȱ�lZ��@J4�ȱP�B5 J�a�cq�xbD��Y�0�����Ph�h�
�O4�u�j���a���]bsǵ@Zsϕ@Z��u@Z��U@Z��5@Z��@Z���?Z���?Z�Ƶ?Js�S����o��~�枫~��k~��+~���}�晫}��k}��+}���|t�r'�!��9A����s���<p}��<ru��<qm��<se�ּp]�ּrU�ּqM�Ҝ�$�2Q��|3�7s��<Z���<Z�ȕ<Z��u<Z��U<Z��5<Z��<Z���;Jsʉl�G���Y��=W�h���h�#W�h���h�3W�h���h�+W�h���(��ƕ:Zs�u:Zs�U:Z��5:Z��:Z���9Z���9Z�µ9Z�ʕ9Z��u9Js�:P��5w\��5�\��5\��5�\��5O\��5�\��5/\��5�\��5o\��4OW�h���h�=W�h���h�#W�h���h�3W�h���h�+W�h���(�����o�km��+m���l�摫l��kl��+l���k�敫k��kk�支�zs�u5Zs�U5Z��55Z��5Z���4Z���4Z�µ4Z�ʕ4Z��u4Js�M��w�M�)�M��6��(���\=�5O\;�5�\9�5/\7�5�\5�5o\3�4��D՛;��њ{��њ��њG��њ'��њg��њ��њW��њ7��љg�M�o��f�6Fk�2Fk�.Fk�*Fk��&Fk��"Fk^�Fk^�Fk޸Fi�6��њ;��њ{��њ��њG��њ'�њg�~њ�}њW�|њ7�{Q����^��k^��]uM6ϗ�����y����̻�lK�3O��߾3�0�fg^��rg^a.�;���&�]���M4ٮrg�`�~��M4�~~g��v�;s�N��̡:ٮrg�ɖ��9T'�Y�̡:�3�3'թ͑�h�M����9#;s�N��ٙCu��������;s�N��ٙCu���ΜT'Z�w�P�,^�3��d����&��̡:Y�mg��bV;s����P�,��3�V��D+�z�!7�d��9T�����:g�L�Sk>��ԚϴªE�Iu�7�W#���T�e`�nU�%=Z����OtG�ҭ��v��s�Ѻ��}^o����`�9Z���ϋ�h���>�գu�[o�韼kM�4�����ѺkM09�+J`O���?�]_��2����C� d$��'�>8���>9�	�NL�>1�	 Q��M�> nr���' ʈY� �����>P��%"~r���' DP�7�{P��|��O ���o0�	�:��A��v�W�� _��?��	 p��' (�|o�O P��S�� 0'�?��(�\����>@��~��x���' ̉�~�9Q?��a�o4�	 s��F�� H��'�n���P.�|��w e3�w���8D(�)���~����/\�
<\I\�JV\��c\�*p\ª}\�j�\���%��)��<G,���/��"�2��6��2G9��
�<��*�?��CW�(��֌m���5��<y�<A���u��"GS���V��2�Y��
]��*G`���cW�(�������@�����3��9����d`	+s��V�b�%�ʕKX��V�(�׌!�k�5��$W]3�v9T�2���)>��(X��)οU(�U)��(�ՅPM��	�(Q��)��(ٵ)��(��)'�U�=����e����OX�7�`��"�]����tZ����i	+p��%�ȝ�����Z���j	�p��%��ݢ����Z���M�{�?a9n*�����V�vSKX�{O-a%nD����+�V�UKX��U-a5n^���6�d��席���WKX�^-aE�~�����V�XKX��d-aU�ո}�V�#^a��t�OX��J����W��',�}��un�w�Կ.,�W�fvK�P��v�"MT�ٵ�ո��
5���h���mK��J��5ߑ��ٯVj���h�:�mk�/j���
7
    [ª�5l	�q�,j���F��h��9ߚ}t�N}ktOm����z�Yc{/V��dKX�[�-aU�[��ո��
5��h_,��͖�<�:[�
��l	+r�%��-і�2�G[�*�,m	�r�%��m�V���5a�b9n������V��kKX���-a%nʶ���C�V�vmKX�{�-a5n䶂E���W+����}ѵO�~c��oKX�;�-a%n����G�V�qKX���-a5n%��E����+�,e��X�;�-an?����V��tKX���-anY��U��V�fv+X��5U}O,�m<��[�
� o	+r7�%�ĭ�2��[�*�4o	�r�%����V�(_k:�0�7�[���uo	+p�%������7�[��ܩo	�p۾%��=���7�[����m�x�S�kr��Ze�5s��4�4�X�;.a%n����W�V�ƁKX��.a5n)����`��|��r�lp	�s��%��m��"�$\�Jܠp	+s��%�­��*�1\�j|��Tg��pG�����ٓ�9>1w|zYk����<��e�y�s�Z�ħ����,k�w��B�W%QSPS�~b5V�
�5��'�c�,ay�V`-aE��V����ȱ���t��k���ͥ>1/l��%��k����V�e/����u2ja� iӍ��	�'v ��W�n!H[��{t��?n� �`�ڌ��';@@رb( [��  a�� l}2��/D'l}�8<�P�;����ix��~�J�P��s� %J{�� P���� %:�cWb�Ni3 A��8; )� �%���j�AX:H	 �R����Dv�aFJ �g��k������� $�X�P��M�@��A��Vg�3�(mָ@���r; �(�/�@���r; VggPb!%Z �����Ę�_��Q2�{���B ������ca �:'�� �s����9�?� @���*V�$W� @���*��s� @���+����� �-?!�r�6�+�����=j���3�P��� ��@:ʟz
�%��d�����qck�R����4j���ߟ�3��'�烜G뮘�7h~b�+���V�գumgo�?Z��>�u����>S����u��m���q�ųm�_�i��֩[�����E%����>-|���ן=�������ǯ��������������{�wT�S��70��u��0��H�ہvF�� 6F�%&�ۨa�����ᩝ�����m�H�vl�D�l�L��l�B��l�J��l�F}�L�Q+���}Rҗ��=e"P���%�pSw�9��M���J7u��#*�ԩ�#��ԙ�=��XN�cOXL�|O���zSw9��vS7�9��u_�/���%���ü�Q��n�?�O ���iއE�w�Gs����N��y������h�}�&�� -�~���#� qŎ���< ��A
Jp H�
G@���� ����@z@@ ;��h���AN�Ei�#��ӛ(�p �$�&�*P�(�{@�����A�T���3"����@s��@���9��hN�D� �~Pߡ@��0�"���= J��t@��0��i�K�� �-��D�g$%�3r?M�? ��i��� %�2/G �(J��:[ �:r?Ͳ2!���� %�'G �(
�]�ղ6"��DEFG )�0�TR�aaA��X=�{�޲��p��g�Nq�wP �|�
��3���8q�ш�/N��<< !�`�eb���aZǑ)�����lPb#%Z~��-?�"Kz%�ʽ��z ���Jĕ{��4\���_��{�<:��>�Vp���(8��@�\�O�*u�¶�����(�	���^�he����s�0��F�#������A��V�#�W�gDt��vϕ��;��@�#g�Q���q�%r�p ���t+���Dq��0 J�e' �=�g$�l(6� & ���?aP���	Pl&�� �fr!M �ɥ<��W�����}��� �&@� ��8 }2�Ut4�p �'�	�O�        J�:�Dy�c@���bG@Wb�9 ����� %�)O`Pb
 ��" %�%�y(ld �JDI=
 r%@@���EGC��9Q� ]�E�|O ̉r�i`N��T' �Dy�e`N�oq& �Dy�e`N�9<0'z��3Vg��6 J�)�R.P�<8?�DQE� %�3 J���' �(:ct�-:�E�_� (Q�[�
%��	 %�� J��' �(OL (Q��� P�<E2�Dy\y@�����y�	@J4L(��h�P�(�M (Q�;O R��'@�r�y@�r�y@��@��塰	@��A��Vg���Wy}� %�'���kӿD�|S�	�	@�D�p�/��G <�q�# ��@� �E�R� �Y?q��/��
G <Qc�# ����� �Y�R���,O�N (���H������͌��<n���Dy�p@��� � g��L' �(O�N (Q�6� P�<q=H�x��X� J�W@L R��'��ly��DE�fhw��� �P�hN �|0�@>�   L���Jl��� d �R��\�Е�(� P�"~���D��2 P�"~0 P�"~0 P�"�6 P�"8? P�"Q5 P�"Q5 P�"Q5 �D��DE�����D��N� �� 9E����������Ѽ���� r,�3] JT��Vg��cQ�.� P�"7 P�"~0 P�b�6 P�"�6 P�"E2 P����PhN4(�Мh����h�T)ǢH� ͉�'�}�A�cQ� �DE�` �(\�@<Q?� P�E� ≊��  ��� ��� ≊�� P�Šʱ(� %*bi %*� %*�> �cQ�� J�W�O (Q~c@��� J�C� P�� ���0 %*"Y@s��'�Ǣ�
9���K �Ί� @������Y��Xui %*������r,�#� JTd8 s��.��H��) �Rui %��&�l���KUd8��}�� %*�}@��A���h�����} <�
�X�+uTʆ�A@�%�9�l��X�!~�cɆPX@�%��B�0q�K��@b�w� \���	� �	��	 �	K9�;�  ��@�dy�j�i�<M4�i�x,L�vI�G�3����+ɣ�� �        �� ��L�rKA�3y����!V ��`h u0��P;�@��� ��;@ @8��  ᔶ���;��ʙ�A:�� P�4Q�@���� %JS�3 �j�ta��D鴾@�����S��-N�-Ne N�J7Y; �2�<.אn4w \�!��v \�!�+� �cI�91޷rO��cI�Yyp g�� |�;@ @(�  �
; ����c�Q��T���K�0; .�n0v �Q)��  � ���4 �8 �:�  �'@ @8��  �p� �D�c��WҰ� %J� W_I]� ��I���p��4��6鴾�6i�{�%lR�}�%l����Kؤ�; �(����D��@��-� %J�8 W̆ �d� P��X� %J+av (QZ��@�Ҳ� J��w (QZV�@�Ҳ� J����+fC�nug���q����_Xp�l��� %J�v (Q��hu6��>� e�kͥ�������Di�wx(Q�w��Di(l������hyR�aB��!����%z�'�4�9Q���c1�D�
�����h���+,H�� P�4��@��8� %J�y; �(��� P�4��@��`�@�a>����K���v (Q���P�-���t]�c@@��	�JYy j�f[�� �ٖ�& j�囬	��0y4o ���Jt@U�4ϴ�f[�#j��u�; �(m"�@�ҳ�; �(�Ȳ@�Ҏ,;     )Q<L (QZV6���h %Z P�<�:�DyHt@������	 %�c� J�Gu' �(-+��Di���s,Ҳ� J���' �(-|��D�!� 9Ŕ��0 !I#�	�  �P���` * ��8 ��)�@� ]D!�tO��FWah(���gjT�T�yg�"�M��> ��~�� �'�|�#�(�B��cc r��'H���!!�EBj��o�3㙺�G�ʈ ���=���G7���Fw���F����FW睼�\������j��@���ק5���g�y�9@k�y k�O Zs�.��<T��U��`��^i�m�W��`�m�5��6�wG=�&qj�}�:= ���
>=���B5 n�� hP�@��p� :��m� P�$~��%q�7 �(�۾�b���x�Yp2�̂�<if��\3N�Yp2�̂�y��5O<x�晇�ּ��њW6Z�ƃFi�7Ӑ��4d�7�LC&GӐ��4dr6d(=�'�ǯ�ɯ��������ˈ�E�~|{!"�q����ke�Ѐ�>t�F�-��CjD�Є�>�R5"L�jD��RՈ�1���cj�"(:�LOA�)���F�N��S�dS�dS�d�S�d�S�d^S�d��0�=�Gލ�z߾�������w��'�������=��G�?���?�(�Q��g��U�א�͡�s	�{H�/au6lkP}��m*�Y��J�;�%����E�z���,w�v$�zF�����/a=c�KX��KX���KX�C�KX��KX�׾%���V�Uq	�����6^/��/�KX�W�%���R���*2USV�yds���|���.�L��Ͽ����~��g��vw��o��q�������D$C�?�	q;��VL'Q1}۽u7���+2�u��XyU�b��5#��l8�n�<��V��֊	<�[1��#+晆�b2� ���+��c�4�ލ���Ɗ� ���N��f�z6���V�;gGs�/Y��#��y��h���χM���#���G�7�->�W���>�ќV���Tb��S�EF�GA��h�5'�����y������5m�%i�Wm�k��Q��<�>E�;�>E�'=�>E�'=0J*h� �Z����t,~:�/9�ŀ���:@�I�&����⧌
�$�	O@xƥ2�'�1�7 �%#� �[��x�nQr8�Pi,k� ����l����M:�P��t����4��i�_��[M�II �}�ϜSn}�%y�[5y�YT���PnY�U�PoY���nYԚ� (�ɒ���x��\K��$)yY6�S�ּ�P��QO4)�l�E(9��f��aKD̀|��>J��� �_�jL��F�1X���VC$�����L�ȍ�TP���o�����ɛ�����y��i��ͼ��t>M�f�����}8����y�_?��~3�0??�Iu�=��9��ԯۘtޕ|3��Z6�ơDk�U�����K����_���麯7s��|f���;�8�������4ש;z��bQk�U�_�\w�T�͜T�x����P]U�2轔��~�̡���.�o'�?��f�U�T�V9��	�7s���Ui�U��\�f�����냱/���q��Y�9t���_���0G�,�~�h޿z��򓹇���̅�d޿:rh�H�h��1�H���s����9���pP�&���:��q,*E�
�f,�`	+�hX<4����%�̃f	��Zª<�����,d5 �%,ǃv	�󺱄x��������0KX���%��Ves	���`Ս6KX�� KX�=�%����V�0�V��V���V�8�V��V���
V�8޵��tŗ���V`gm	+�߸��؅]���M/a=�%��1�%��n�V�6�,a9��,ay(-a�m-aE1.a%��-ae�e,a���Yݵ¾P�i��G.c�*'A���fv?��};�S6�s����,ov?+�����f�s�����lv?������f�s�����`!5ft?˙����f�s�����hv?+�����f�s�����jv?����%�l��`9��9X��~V0������`%��9X��~V1���U���`5���������r�KX��~V0������`%��9X��~V1���U���`5��������,gv?˛���
f�s�����dv?+����*|>�S`�>ߋ��|O��}��-��^,���{����Ŋ|�+-��^����{����Ū|��-���,J�Z}��-��^,���{����Ŋ|�+-��^����{����Ū|��-���,J�Z}��-��^,���{����Ŋ|�+-��^����{����Ū|��-���,N���*�{�>ߋ��|/VX��Xq���b�>ߋ��|/VY��Xu���b�>�ڶ-��^,���{�����
|�+.��Xɺ��'Xٺ�Xź7�Xպg�X���`9sY��rֽ����=��
V_ab��V+Y����V�ob���&V���˜�,o.c�X��X���X��X�:��e.ߟX�/�X��Xպ_�Xͺn�\��`��L,o�M�`�N�hݯN�d�GO,��~b��1��5n2���O,�ךb0���N,o��'V��&V��'&V��M&�9�3��5�4��5�5��5.7X�\�9��5�1�����|\ˇ�2�|leb%��8X��?V1���e�K�X��Z��7��8X��?�7������`��)N,s]���f�q���,s��2�,�k���`9��8X��?���~bE��8X��+����*f�q����f�?X���X��?�7������`E��8X����f�q����j������=_;���,o�+�����f�q��u
+����*f�q���,����l�f��|�
�Mzf�ϝL,s;����/VZ�?�Xy���b��[M,s�����O�k����2���X�s�+,�_���|���������|�vb��NM���|����|���������|�vb��㋕��/V^�?�Xe���b���e�K,��Z���-�_,��|����Ŋ��+-�_,s۩�U��/V]�?�X�:����k��׮�s(_k�_���|����+-�_���|���k'V]�?�X��?&>KY6������2�S�X�6�+�����f�q���,s��en�9���,sߨ�ʛ�,g���Vvb��8X��?V2���e�5���'V5��������lf�q���,�y��e>w2����d�+����*f�q���&V3��,������rf�q���,�9Ée�5����l������2���X��?~�(_k�˙����f�q����'V4�������`e��8X��?����/J�Z��8����`���'pb���O,o�'V���+Z�ǉe�9���FL�b�'V����Y���r澰�|]���V�qb��8����X�~��|M��*V�qb���M�f���ך�ǉ����2�S�X��?N�h�'V���+[�ǉe�#2����X��?V0���X��?N,o�'V���+Z�ǉ������V�qb��FM�j�'V����7��8����X��'V����|��2�ωWQ��?gb���L,s���e�3X��?gb���L,s���e�3���s&����2�ϙX��9��?gb���V6�ϙX��9��?gb���L,s���e�3���s&����2�ϙX��9�U��s&����2�ϙX��9��?gb���L,s���e�3���s&���`Us���e�3���s&����2�ϙX��9��?gb���L,s���e�3X��?gb���L,s���e��Y�2��?gb���L,s���e�3���s&����o��9��?gb���L,s���e�3���s&����2�ϙX��9��?g�����2�ϙX��9��?gb���L,s���e�3���s&����2��,o�3���s&����2�ϙX��9��?gb���L,s    ���e�3���s+���L,s���e�3���s&����2�ϙX��9��?gb���L,s������9��?'�����2�ϙX��9��?gb���L,s���e�3���s+���L,s���e�3���s&����2�ϙX��9��?gb���L,s������9��?gb���L,s���e�3���s&����2�ϙX��9��?g�����2�ϙX��9��?gb���L,s���e�3���s&����2���j�3���s&����2�ϙX��9��?gb���L,s���e�3���sb�w��f�3���s&����2�ϙX��9��?gb���L,s���e�3���s>Xa3�ϙX��9��?gb���L,s���e�3���s&����2�ϙX��9����s&����2�ϙX��9��?gb���L,s���e�3���s&���`ys���e�3���s&����2�ϙX��9��?gb���L,s���e�3X��?gb���L,s���e�3���s&����2�ϙX��91?kaC0�ϙX��9���s&����2�ϙX��9��?gb���L,s���e�3���s&���`%s���e�3���s&����2�ϙX��9��?gb���L,s���e�3X��?gb���L,s���e�3���s&����2�ϙX��9��?gb���V1�ϙX��9��?gb���L,s���e�3���s&����2�ϙX��9�U��s&����2�ϙX��9��?gb����{�,��?g���s��?g���s>X��?g���s��?g���s��?g���s��?g���s��?g���s^��������`������`������`������`�������������`������`������`������`�������������`������`������`������`������+������`�����N���Y��9�e�3X��9�e�3X��9�e������9�e�3X��9�e�3X��9�e�3X��9�e�3X��9�e���J��9�e�3X��9�e�3X��9�e�3X��9�e�3X��9�e������9�e�3X��9�e�3X��9�e�3X��9�e�3X��9�e���*��9�e�3X��9�e�3X��9�e�3X��9�e�3X��9�e������9�e�S�}_I,{������,{������,{������,{�������`5{������,{������,{������,{������,{������y��f�3X��9�e�3X��9�e�3X��9�e�3X��9�e�3X��9,g�3X��9�e�3X��9�e�3X��9�e�3X��9�e�3X��9,o�3X��9�e�3X��9�e�3X��9�e�3X��9�e�3X��9�#����`������`������`������`������`���|����`������`������`������`������`���|����`������`������`������`������`���|����`������`������`������`������`���|����`������`������`������`������1b���L,s������9��?gb���L,s���e�3���s&����2�ϙX��9��?g�����2�ϙX��9��?gb���L,s���e�3���s&����2���`���?gb���L,s���e�3���s&����2�ϙX��9��?gb����3�ϙX��9��?gb���L,s���e�3���s&����2�ϙX��9����s&����2�ϙX��9��?gb%�1������z���ɖ����ן~��0o_��o�	�]�?�ּ�<��+̳ڼk�8�9ҭ���\կI��U�5����N��jsdz�hК�;�9��>�h�!�M��)[���	����8K��g��4�m��O��hjsڜ
E;�S�E�۱�ް��i�����G_
�o����'����_} ��ek���}Q"�  �<y5�oJ6,�j@��-��'���d �/q��K���!@� �|������n���_֗��5��?{����?�����_������+������������5# 9o �+���yw�3�N~=9��� ��Z/ '�������\:y��m���/ 7��
r��n��Lc�
=�W��1讘�
Ơ�W�1�K���H�'c�+�`�ܮ��
��v�H���
�U��x����2�`�btWZ/yϴ^1+�`�b����]1���b�+�c0_��`�. cn��1�c�a�+T�0�%_���W�)c0^�6h^�Z/�E�Fc�2����/�/��^��.Xa�y�3��+���i�]�[l�����m���*p_�v�:X��w�y�8m\�:Gc��Y�����	�s�����k�����`Ah��+F��1x��hx�+f$H��+�3&}篘7 e�.yf��pż�^�F�7m�m`/z�6�W̢x\�.���^�Z�E�pŌ)�p����K֔@c�2�E��3>��dWh^1������KV+�c��b�1���
�X���1� ��.y4��� ���%�{�v�{�^4_1R&p�2���)RL�bwE4��t���� ��"w\�<p���Dc���9��B�j�K��r�W�+�z�6��+��Lc�2���%�?x�D��]�M���]QeQP'��J�ɸ+��u2�\�1/�l�N�]�O)��W��bwE��Z/X���vF��}���w_���?= ��M��p�W=�ڸ+���RzŐ(4���X���]Q�XPj�H��ڸ+J
Jm���=��������]Q�PPj����Jc���6�^�6ȥ�b)��R^B�̗��W�mg��F����6�"���]QHW���Tn�1x�,
���+v����s�u��a��`�&̕�`Eʕ�F�R�z�H�(�q�2��r�
[�Ԧ\0R*�ڔ�J�6�1X���r����`��TjӮx���+���6��sE�F�b�\QjӮ��V�ڴK�e�]����o�+v_Y�vŮ�"�Ү8�S�nW���1x���i^�Z�Ԧ]�篞��%���%���%�c��]nE�M�dǈz�v�TQjӮ��+Jm�%�/�´Kv���+T�6�}]�1x��4/yf��+"T}E>�w���30^Q�Ӯȸ�@C��i)�vE(�"�߮�Td�%.C�!|ŶɜvE`�"ծ���x�튺���K�"`[#-�����^1R �vIH'�2z�L���b�i.�K�>5gE�N����K��A��=��W$�*�.]�6Z�+��j�@�b�d�kJ�x�W����z��>G�/yϩ��+j�k���H�bf��+��5c^:CW4�ƾ/�����/��������+f��1xE�J-������� j�~�3_��W����3�%z���:�V�Wxm���+��������]�W����8�^+���f+��^�3G_�pE��Zi^��؋^qf���l�����m����6�W��1xE���޶���-�+��k�^�2�����1xEYom�WJ�c����m���j�m�W�E��r�|+�C`�m�W�Y����+r�_d�";�p��%�Pw�\R��p�%/��lW�(n)��b��Β|Ŧ��獴�ߙw9�g���r�y�����z\@�|����)���y�d���\@�|+���w�\@�|����=��3�"u��R�+ߎs�y?�zrx�B}��]g�=��v9�q����]@~��~9�M���gx��mj��Q��7�m����?/ {���r�A/ ?o�����șoo��\���ȕoý���.��������){��M��ߗ}�y����w�_@�|C�����_@�|S��>/))�$wIM�vEJG��%gXp��oW�S��v�z�S����	�%��T    ����ԉ�'(����7��3��'9�i��q��m��|3�0?}�y@���=�o�!���)��'����)��S���ձo截o���|3��4z�J�q����?�Ӽ����2w0�����o����w�j�fVl�����.a%�Lx	+���KX��^ª|��V�����m�F�����v	��=�KX��^|�V�ې��2_���U���%�ʗ&/a5�Ayˑ�W�_���~�%,�W/a�uy	+��KX��]ˏ��Ņ{(wTvüK}�'w ������}b^a~���Ȏ�?{���9�[=y��'�������s�z�^���y@m����'����N�^�9v�Qo�]o:����#I�yd�pɎ�)/��Ԛ;���+�j�5���#i(�>�5O0��u�.�l ���+'��O̡���T����:�l��A7Z�y�wW8$^\P�H�vj�!���o�
[��+�^u�VX���N���]lE��>V�d��_��o�Bc���ngC��S����y��O��~���?ා_|����w��t̯v �_� � 4�Q��9 ��W����}`��h��@�y��5O,�&�Y��}��&�?)y	��%��D���j]�*O�.a��~��_?��c뿢�)����w��ek���UP�-l�!����ޅ���pC�Wf�0�7�x����'6�NU�ۻu��ձ^2&� �y��Q��Ϗ?�.����+��o�E���W�����/�?y����y���w�xw��y����NtH�(��i$	�og��4]BB���7@IH}�n�>�'!���}�����'�����IH�nɷ���}�����@Z�Lm�o�V��H�,8��!��ݑ�%�� !���~�ˇ��@�f\BznT�x�U-�����U,��ފ�]�X:���O��� >��v8 ���$��u���/H�{�v0
n�������g������P�IF��o���^Fzn�]_۷O��d�[����']Z�.7:����!�d�ΰ�������s���2\g|s�=���)��^F��̌�;�}�$���o��d����C='Щ�t���:Ս���:�vA�9��N��sǷK�O2��7##�*U##�"n##�
�Zj��-�1���V�z�%�ʥQKX���V�(�*���vm	�s�V���V�ֳKX�+��2�-aN�-aU��-a=��+X�Jk~#BH�.ay�/aNL/aE.�X�J��_�ʜ�]�*\İ�U��b	�Yڱ��6�2Y�r\���f	+p�v	+re�V�:�%����%��y�%��)�%����,hA`	�q}	�s�V�ʂ%����%���KX�K?��
W�,aU.�Y�j\���U6.Z�r\���幌e	+�ы%���0���X��|Bc	��I�%,m/A��t��/�����}q�!GM�ޚR7J��Mw�(��F�U���!%����V�m�"F���e�qWB�Sq�O�-�H^*!8z;b�:}M�'� �<�ѯ����`�=��+!�6��V2����v��G:Q�J&HV��	R��db������I@ǈ��o��o����S�}��)�����!|�"s���3�)D�޹����y
Q�o�:E�����}�}��]N!��-p����)B���%bΣ�קg�."!z@�B���<�]����}(8�f�`���"ڬ5w�����=�O����:�lρO�Q���_]����a3��yAQo��[�u�L��Y�^Қ���椺����)����!⯫�| թ�L�/Fdh����q+��A_�X�E�����
V�x`.a9fKX���%����V�Yx	��%�����s�_ª��.a5�+X�y�I,a9�b��<O�KX�7KX�7nKX�W�%��{�%,�޶��}�q��mw���l��{۝�|o�3��mw����\��ݙ���;s��vg.�����{۝�|o;���vg.�����{۝�|o�3��mw����\��ݙ[����쥻��X��G�eo{`U���Ȳ�m�,���Ȳ�m�,���Ȳ�m�,���Ȳ�m�,���Ȳ�m�f��Y���e��Y���e��Y���e��Y]Z��B(R��K��:���Ѻщp���+Y�pxE"��'�p8�wk,�������Q ���U�!?Aѝ�kP�^�T���UD��8��|�7�J�~�n"���&���ډ�~��#��#H}�6�d{4_x�[�r��Lo�>_d1� 8�z��8)��5���+��:x:.�; ������NF��F��n�ќ.I	xg�+�y��h��V��G������s��)¾e���|Ϯ7��·�M�?1o��j�������i�h����ΐo�(
:���<�r��h���?�9�g����oX�B�����¿d	��K]�j�}W��lʓ*o,Ǫ_��< ���KX���%��3�V�a��Ux�Xª��-a5^�V��X�ʼ���1�'�n�6U�"LY}������
wߟ��t��ϙx���'AY?����w�}��r>���ͺ���Wެ�d��}���|��ͺ���Q�u�_�|��ͺ��7�>ɞ��Y��ʨT�j*���7TR	�PY$xCu��UE�����Sc����Wk��E�y�N��TF�M%���G'4��Rh��<߂�ܓ�19'��K����4�c�(h�x��7���?t�}�ǞP�x��>Px���&�F�٧[�T���C����+��������/�;��o����g��v�$���}�|�X?����n�}��~d�}��k�}��(�?&�ܿ�����-���/Z�������>"�����J�o�]Q����+Q<O�]Q�~L�]A�����I�Q�;�O�P�;�O�O�;�/����^��ǒ��w�e���h���疒A8��ǡ����"������Z�_�_0����a���^0|?4���3;����Vf����V�O�^���}�����=�K��g�G� �~'{����a߿]��?&{����o���^��&�������c���=�6Z�q��|DK�� ܢ)�O \!(w!&@@>> �o�;! 7c�W�	������'����t��W�H (Q1 J��' ��-?JT�& ��"_�' ����H3! )�0���,I %*���9�0$R��3B��i} H����I��w ���w���h�ܺ"�M (Q�� )�0�஧�˿B�� �'�W���ON>�@@�? �m��eU �)m P���i P���R��d�P�mwN y\i�d@*W���͕\>�@B�?���n
i W�ߡ ��?�P􀀟`*�0�� (�����Q�%%�o R�a0UR��	�(;� �D�X@&&F= J̆�D�I���D�r�u����:�
��1�&�/�|�.��ZW�8k�ŋu�	ْ,)E�[;�k�=E*�ց�Z�HQV�u���:S�Sk](����]�Z7�m+��	�QB���
��֞��Zk�	k�#et�։�Z�L�\��Lk�Yq�[Wь|�n��}��,��ډt~���Y�hD3��:��ԣuͩG�,���E4+��hn9Z7��p�F�2��z�v���h�E���Z6���h�t�N�]��:�v\G�"�3��hN=Z#|�I6�t�1&e�&ӟ�6�>��
��Ϗ�H��u��J�u��8�u�j8�����Qe���S]��:PU��:RM�֚n�W[�	A�u�jT�u�ZT�ucY�M8�3TJLk%�� �$�pt�eQ��x�Wt�eQ��HxIh��x��P θ;@@8�� P���# �u�%"d���3R�$�x@���� %��GG )���DQ���E!�# J� (Q�68 2Ϣ�� %�"�G �(��<�DQ�� %�j�� (QTdy@��t� %��C� R��'@��d���y�P�����E�NG ͉%bK���%B����@���%B��"�# J�jP�(��dj�$�9=��FTtzx ,?�DEǾ���^���*�~ �3��`R�    ��(y4 �Kv�D J�%���'= J�%:(Q�� %V��XJD3�$�
80'n�S�'%�Z"eIW�7 Vgg�
h�EGI� Z�- �΢:�# ��4ظ`u�w R�a>@�',j �
X�� (Qt���Eg�� R�a>�D Jt�� %��� (QT5x@����# J�� ��ˎ%]��Z�# J�lq��DVP<�����D��e%�G �'�8�-/��> �ψ������-���ь# JK8"���2!�RAY�_:��DdW�!(�T��K1$(�� �g̤DÄ���� %���z��# J4e�� ��c)��,B�`��h��B��aFB�Evh� %f$�Xd�� (���ȱ��zP�!(�)���DCP6#�";�{  �";et@���*r,���G ��%"�Ry�\I��99٩�#��l,� ��T� %Z|&ʱX�8�c�D4)�b	D����r,��(r,���;[b��c��T)�b��R��S-ȱdCL�l�w�+�l�D�X(ȱdC�� ǒE�ݎ DqD�ݎ (QtT��E�Ŏ ��J,ȱdс� 9�,:(u@��wG VgC@� ǒE'/� �-?��!�X�c)��7���XW}1���b��m�Ő_���!M�Ё/�������b�/ʱ��!�b�/ t���� a4_��|1�J�Ő*+�c1$��X5�r,��B9CF����P��P���~ߩZ~B�'�
y� �� �0 �0< �0 �i��o�&@���	�ѿ��K��8�D��5�D��7 8���i@�r�m@�r�m@�r�m@�r�m@���� �W�	 %��� J�{m ��3���<I3hN4|�ܕ��)�	 �<A�� !ẻ�,�( �D�R�U J��L��SZw�;�0�(Q�2� P�<e:�D��2�Dy�t@���	 %��� J��L �/�B�� ����	 %� J� & �(@L (Q�� �O4̉J� & ]�cPb�>Q���}�eej�:�B�>Q�k� �'�sm �Dy�m`�(�;O ���D �Dym��>Q�o���y�����jݠD��RqW����M (Ѱ2�J4l4�FJ��D(ѰѬ�
�6�u�ͺA���fuP�a�Y�h�hV%6���;�F�:(ѰѬJ4�}�A���fuP��s�J�W�M (Q^�6 ��D�g�P�<a9�Dy�r@����x�AHJ��L (Q��� P���� %�4OJ4LiJ���� P��2n@��2�	@�D�KP���t�-_J���N (Q^f:�Dy����e����<�X�e��� �(/3� P���l@��2�	@�A��c���N (Q^�9ű��X�e>@��[�ȱx�`B���k�' �8�����K� ��Xr,�2��c��D9�`���wF��[�FʱXV&ʱX�3�Xq�J9C�R��G��c1đ*�Xq�J9�N�r,�@T��e]��!�U)�b�dQ������c��!q])�bȽWʱ2ߕr,Ǔr,��y��!u^)�b����c���c1�*�X,�ʱj0*�X,�ʱX���D���JD��Ji*r,�?@��[�ȱxK� 9o� ��-�ʱXv�8��,�r,�!�ڐc�9׆�fȹ6�X6Cε!�"�`�D �c�!ǲJ(r,��>��K3�h6�X6��	@J4 �c��E���i��s,M^�=p��Pn�p��ʍα4C�q�9�f(7nȱl�<Ss�DÔ��&? 1 ȱl�KC�e3$mr,���!ǲ��9�͐�mȱl��mC�e3$m�'%Ƃ��,B�I�H� �hH�6�Xd7KP�!iېc�ݮy@�������# J4T6�
k�9��2�G�����@��a,�WX3�PZ��l��z�5C��E�� D�
k��AC��f�4�
k��AC��f5�w��mȱl�mr,��ط!ǲY�r,��_@�e3�hȱl�)9��Pfڐc�g�r,��L<��YF#r,��LWC�e��ȱl�@TC�e3ĕr,�!�ؐc����f�lcM�:0(9�Ͳ� ��,�BJ4Liȱl��XS��l��cq�Y9g�
�'�r,�D��Yȱ8K8��c���lr,���D J���cq�r,�D��Y�8t���s,�p r,�%��f���9Kd9���/ ǲ2�Ev�Aȱl�Z�c;�����Z��Q�E_��6ʱ�kq�F9}�A�(Ǣ?I�6ʱD�Xh�X�eem����!C�j%��r,�Z��Q�E_J�6ʱ�+a�F9}%LC��J�9�M��m�v��	�D}]ZC$����I�m�c�W@��r,�
��Q�EKk�X����Q�E_��6ʱ�+ �F9}D�m�c�W@��r,�`\�(Ǣ��h�X���m����m�c��ⴍr,�:նQ�E_5�6ʱ��/��r,���S�m^j�J��<S�����Ĩ�t@@��`�	 ��? ȱDE�v ��\���Ky ��"�6 O �� @���� @���� �-_JT�P ��H� p�%*��@J4H9���#�{W r! �D�&k  �8  �K��Ġ�d@@>��`�	ȱEc �� %�'��� @��}� @�
�i �D�>q H����I����KP�> ȱDi\���v��:0'Js�; Vgi�l��,͹� X��e$; Vgi�u��,͹� X��y� ��4�`u���f r,Q�s�H����K��w� �p]�H� ���; �(����Di�}�x��Iu��E3 9�(];�߷� (Q:+� ���� s�t��@��]� %J� J�.�; �(�`� ��[� J���& }�+�g���[� J�n�w (QZ����_)��|Z���	i���� %JKiv Z����!IU�ҽ�=8 �����,͹� X��9�  ~��+1Is�;@@,�	P ��	��Y�s� �Yy �cIҊ� J�Oi��hy(Q�6�H� ǒ�� J��@v (Q��� P�����D�e �cI�� %�r,I�C� P�|�2�D�c@���� %J�; �(�x� P�4,�@����@�%IU; �(�� P�4��@�ң8; �(�+O (Q�_��Di�s�����Di�m�����K��w (Q����Di�u���� J�V� 4'��K�VD� P�4۷�>Ѡ�D�D�pF�%I+�v (QzDs��A�	 %�#� J��' �(�O (Q� P�<4>�Dyh|@����  ǒ��	 %�c���h�r,I� P�<4H��� %�c( J�Gq& �(��N (QW �X�<�=�Dy0n���r,�b� J���D�q� J�����Di9� %J�� �O4(�Q�0���|����E���P&@ @,�	i$ �/q�w䑬	P�b!M�z����hx�`� �m��,�L (Q՝ P�<�<�Dyd{@��������	@J�� �Ku�^���*yc@�� � �B2<��������	 %ʗ�	 %� J�{m J�G�& �(��M (Q�� �D�h�P�|u� P�<�7�D�g@��h����	 %Z%ʣy J���' )�0�y(Q�� %�3�+1�k�& �-O %�]�	 %ʝ�	 %ʣ8 J�G0& �(�`L (Q�� P�<4 (�@� %t�Dy4o@�����u J�WO (Q^�8�Dy����� J��\@��U� ���Rv@������	@s��'��b�	�X� J��PL (Q^B1�Dy	� dZ��9C���	@J4�Ls�AJ��PL R� %��& �(OL (Q�{� P�<U6 J���' �(��O (Q[� �D��R�Dy���}�AJ���'@W��V��`}{ŗ\̀�������`���U���v    � ��3vW!��[����3� O`�T+)��-��
%Z�J���c�۷@���r,��Pv (Ѳ?h�Dì���N� J��M (�Ol4'�  ������7�,Fo��X�!�c�`\@���q9oƅ��D�H����c�r@�E|�� %�K�& �hH\#.ŗ� P�!q�S_ �@���5RLQ|	� %\���7$(�b��kyw (��C�2zC0)���8�[�7�b���C�)zC0)���8���7��X��H@9C`)��Ѽ@9ic� ���5�@��A��c����;K4� ��H��� ��H�T� �DäJ9ym���cE�e�; )����4�cE�M�; �DC,�XQ|��@��a4"�"�Qv �"��v�9Ѡ�DJ4��D�� %�(Ǌ�Kqw (ѐ�FX=�o���DC����kd��7$��!�ސ���x{�]M��Jo��S�P����IP��4�7i,��ԅ&�.>C�7�}�Vz�l���R�8ըC_;��e���B���`� ��"�D�XkDc9H7^ * ��XR� 2e��<�|�v� ��8p ;�A��`L<�.\ 2O �Bs&* 0Q�SŎ�A�� ��/�A��w 4��"� &*�@4��J���(�h,�� LT�}h,� g���'P�� @��X��- d�)!4���k@@�F4���u���X�- ��� �'
�;�Xp�Dr\����&�93KB ��!���R�H�|O<����~�9�2�A� &
�r��t� ��;� �<��t'Z `� �g��;� �<��t'Z `� ��1?L/ 0Q���՞:u- 0Q��pm��� L4��]( �(�|��� �(����� �(D0���d- �D�'$��(?�o,���E0g4���6 L����t��堭��L�9��(� ��{��LT `�����X�`. 0Q�S�h,�@ �(�����X�~(�D�`Ac9h�� �D!K4�;/�%���Ʋ=Z�@G�e4���J7 �8B0.��l��Z�X��\� `��ˮ�(�����3Q����ƒ� �%+����� LT�4���h,Y��3Qؕ�X����dA�cvC�B<�v�y{�� &*�84����X��Cc�J0�{��`�h,Y	ơ�d%�}OxН��5��"ĕ
�� \g�X�:��"��5A�ή��uv�E��k,�p�]c�2$���+�p&
����@c9�E� �D!�Ĕ�, ~c97g$�|0h��B0�)LGZ `��Cb��� �(�����X� &
y�HL�`�� ��<rX��ܾ &
�y�c僑s Lr�H��c� �(�摎��� +g!H:V>�� ��Ex�o,�~�ƒ�X�X9�4ұrbi�c�,��H��Y��&+;[ ���5&�;+ 0Q�I��Y�IM�Y�	��,�(D9�5
Q>�� �DA�F!��� �(hm(Di(O�����D�&�Ҋױ�<�/��
�i"s�cBciB �� ��8 �K�@(D P��
	�(D���҄p j�=� ��D4*{��X���I:��D�	�3Q8X�3Q8�X� ���e ��X�����e �g��'
;K�q$������~��R�[KU|��{��D4��a�X�Bc�J(��*�*K�&�OPx0 �u4�*�4�*@0�'�d�>C�P�3Q��J��*�(4���º3Q�=Q�	h,MiSf'�@$4�&Hee��,l(�Og�	`�PS�X��`�r:{�rkCc�¥�z�ٮ^�"D�+K����R�\���R����T��^�X�?�h,U�`T4�*�y��
9Y�� &��TaO���xn��?{��G�<5xG�4�*�`����(,��
�U�xz#��D4�*���� l(h,U�`�TFc��DB0� *��TA&bΙ1Q�Ar&* ~wV `�p��d7 ��h,UЙ8�@`"K��X�����n �3Q�Ҩc�B$�z����*$�W�c�@P !�^��Eh_P��E�`T�c"��X���u,B��:���=̸^ �c.�J�`�� �\�|0${��B�$L�^ ����;/���(����D�=Q����~�`Lh,UP���
����RٸV��( �D�hCc��l\]cd�����U�Xٸ��"��5A6��������u$7��=5�%�D!����"$�T�X��$KU��j��L�Ey���qj,��85�x�����O�;{��`�h,UH�C��UHl�>�^�l��\��l��4[��� ��uP�4 8�"�!�H$C��1���p�#!̞���$��x�D���	 �(\�H4�s&��h �L$9� &�(\���KC����'�"�( �D &
.���0{�Hh,�����h ��r	�.� |F4�K��p�@��%���/��Dz���%��[dOb�-�'
Qݖ|O�BbO-��,�h,����X.���{��nə� �D!���X.!���X.!���X.!���X.!$��X.!�ֲ3Qؑ2�����2Lr�Z�tV����,�=Q�{���'*;RaO�ʭ�'*J��BFT+0Q�P���
�1�+gc� (O ��U��l(&*K����T/Q0g���`ε  �s�����rI?��Yz��Ί-��\�-��\����X.��Bc��0�%Du�%�˥�@�X�Be4�K	��\J 
��RBah,��Ac��p �%(��RB�h,��Ec���0KP4�����D���%���0KP�<4����h,A����%HKP�0Ù(liÙ(liԱ!�թc	���/g��O�Ա�S�Ա��өc	¥�S��k_��%�~��|��NK.��r&�o��:� �:u,A��t�X.As�Ա\B!L~:<����;u,�Pҩc���������]c߻k,B�{w�%Tv�EH|ﮱ��}j,\cj8�k,BIw�E���Ա\Bua����;u,���ҩc���N�%T�v�X�����P�ةc������ �w�X廻�"��t�X�4�����w�X���5!G���"��&
�4:u,���gg���eg���Q�r	Ł�:�K���ř(��X.!?�S�r	�u:u,��T�S�r	剽��(0���,0�:�K���ř(l�Ա\B�m��%(�2u,�P0ݫGq����Y�:u,A�:u,A�:u,A�:K��}���A_�h,A�:K"��%�BGc	���%�Bo�D�'�DA_讱�BGc	����X��/t4� ��%�B�^a��л3Q��X�⡠�D%������Ƣ��X��/t4�(��%
�BGc�����X��/t4�(��%
�9,i(n�p&
{�p?Q��X��p��D!��${�s[ �Ĩ|���LT~L������08�2���,4�s*�Yh �gt&�o�d��D4�(d���fg���X��%�Ύ6�h,AP8K�1�X�)+D0��1 ��g;R$?Q�`�㚆���&ܙ���I�1�柚pw� li�����@e�X�pwԱ4��2�ci
�ci��s��Ov��v$�X���&�(ܝG����y$�(ܝG2&v����D�ٙ(P9�p���m��129��}aP�ҕM�:�.ܝu,]q��c���dg��#Q��w�:�.\}u,]q��c銻OKW�}�X� ��X�r_�:���u,ʅ�8[��D�%R���79�,|�꧳��Ί�KK�8T��&�u�>HM��OM�F�O�H�q:9Y��D!�i4��\�L�i����x��$5���`�rwn0Q��%NjBv -qR�Hh��� �'5!��ksj��BK����V(�	-qR�FZ�&�T�'5%�a��REK�Ԕ0Ѐ�BJ�0QP�hΔ��RE�Ԅ�*����҄�@�x�&�T��#5!    ��.�)��L<�A��ƒ�y�3�Y��.-�	��so�-�&	��s� ��˹�7�s� �����w�s�0چ��S8ynX ����	8y~J� '�W�������p���<ߨA����! ���P/p�<d�<���!�� 'σ� ���;p�<^�<�bA���qs��c�9)!��s� ?��@���~v+�L�I�Q1�ܡN�'^� '��@���S����+�@���S ����)��y�p�z
WdF�$s>�8y�5�<�sN�'���2�y` ��� ����N��yf'p�<��k3
�\�9oB
��݊e�<s^��<��4�qu��y48yYN��TA���u����D���� ����:p�\�N���y,H�$ZM?{@����� �٭�����,�M�'�`�f���@���A��0@P��h#��!���Q�6�|U��U:qn�q� �&F!��ApN*��x#LNJ��0s8)�r8��i�t����pr8'> �cA���2��ү��J�4���A���BC�$�`N*^1���0�8�x��K�@o|��� '���lI��l�8�,f�rc�C^�1� '��>�I���TTZ�%&a"3pR������Ӷ2	�?G�	���
��q�ɏ '�)� ���S
ϠX7:�0!��b��8kʛD�}�@P΋�T�:�0����'ϳ�A`�<O��}������ރ�H�«j$>��4���8M���8M���Ն��D�iJ�����kk@��]��B�i�鏎�$��)񇀎Ӕ�\@�iJ\.�bY�8M�`�✔<�\B��J\.��4%.�q��^i�D���(q��6�O��6J\.x���^n#���8U��^ps^;w%�1��T%''��#�A��T�H:NU��a
��q�� �O*9��uE���(ُ�u%�9������q����:��G\�Qr���8JfrpG�+��(Y��u���:��o\Ǒb ��H���8R�u)�:�=pG����#EQ\�Q20��8JVp�r��iऒ]�Q����8J�ztG�3���(y��u%�:����G�q��j�����~3NJ|�;��j:�ٯ�<��It�v�^�8Aa:NS"{tt4Ų\�Q�qh�iϠ0�u%ߞ���
B�{����$55E�SǑ<C����XV�Ų93voI�#�V:Ba�M�:�o�0a��C`��ؽ%����!��������!������!��`����-���ܴ�;��͠�#������� ��N�w8��YtG����Ew8��YtGȯr�w�����+��g~GpNJ�N��o�����;�܍?����m� 'w�(w�����N���pr��xG�}R��ܽ-����]0�f���pr��xG���1�;�܍����oG�������I���9)�N����I����I��O3v��;��U'�prW��#��]u� 'w��;��U'�prWs�#���H�NJ^�j�n<� 'w�w礲G1�f��a�pr7tG����;�ܽ����n��� 'wc�w8��!0�f�f����.�К�Ѻ#�Gzpr7��� 'w�i�pr7��� 'ws��~v+���zj#$�׌ݜ�;��͏�#�����;�����#'��9���-!��ݪ�;���<�#�����;���<�!�'�H̱���w�bL����w��ݜ�;�ܭ"�#�W�v3����HN2'�l�#�7i�h��{G���H�9�e{(�!��|�H|R��&� ����w8���S���N���'/(%8�xA)�I�J	N*^PJpR�R������%8�(A)�I%��T�)���l�B��J|2e8��'S��J|2e8��'��8J|2e8��'S��J|2e?�Fe8�D8S��J�>8�(���I%s 8�d�'�́Tऒ9�
�T2R�[�dqN*�*�OJpR��U8�[�xG��J,(U8�DS��Jt1U8�DS��Jt1U8�DS��Jt1U8�DS���]��?�<��8�y�w��(_�9'�=���ݚ�;�ܭ)�#��[zpr7��� 'w���I�Q���VO��\?�Ir��6V8���pr?��"8'�_'�ՇN�GW8�]\��~tqE�����a�O�GW����� '���+��
�܏ۯ~�V�b���́N�g�pr?s`E������'�3V8��9�"�>)p2_pr?s`E�X����&�Ɋ�$=C{����w���5�?����q��V��mft����w��b��8�������Qpw�ʯP��~doEpN*��������#�܏�pr?��"����ފ '��r+�sR�|��	�w����;BAz��I�WP��=��@��!��X7�8�s���`�GQV��b���l�F�#8'�N�OJ|<�b��9���8����pr?�"���Ȋ '�c +�܏���J$g�'Nf�����ڇ�8'%��}�E��V�(�z��~bw��}�E�����W8����pr_s_�=���l<�!P���o�� '��Z��I�kR���� '�i�g�K�N*1�L=�v�;�T���z����7�q�{?����eQ����zV8����"�G�~�Q8I=�� �;����W8����pr_s_�q������~�ߊ '�3QW8����"���L��9��EwNJ�N�粮~vK����ٰ�8m?vEpR����L��9�X�����-��i�5�+�ҍ�z����wbAR��z����+B�g{��{��,��lϵ�#p�V���q��dA��J|������+q�r9'�S���t�*�8ۓL�pR�
:NW�����/���t�*�8]�JpN*|@��Jt���t%T�sR��뻕_��3��dA�J|���%>Y�q��,�k��F��J|�����'��8�J[�q��,�WMђ��8�BZ\�Qt��:��{P\���Y�ǷN}�u�rA��������\���|Xܟ���w�q��<ȏZܟ�gԂ '"��<��-p� �� �Ƀ�ނ '��<��.p� 6��u��H��z�b��8� � 8'���.p� opA��y��<�\��A��� '��#�����C+�sR�:N?�..p� � 8'�_�w�W�Ƀ�� 'b��<�.p� ����>��
t�~\�OJ�\sN*;:N?ȟ\��J� 8'�� '��N���<������28y�_�'��Nf����)��'�G��������-V��*i?��{O�B=Nܿo��m�\�ǉ���!��ͨ!���5����\2�ֽ"���HΊ`�L�ѤN�G�V��NR���#{��]�~tqE �dlvI��ڊ�@8ɠ���aW���I-��e]|�����]0��}OlA��:Ί�>����O*o2�O��Y+��~<jE`����V��}dEh (�}��ƺ"��}�wA��Z܏Ӯpr_�^�侶�"��}�~E����+���^X��~Ŋ '���N��8+�܏�/�9��:9'F�W-�+g���� G��ޏ���������{��"pv��W���늀?�k^論�o�+��~�`E��܏h�pr?¹"8'���N��HW8��Z��~LlE�����N�GY�������T�&}�Ҿ2�"��}%hE���
� '���+��W�V8���pr_	Z��� �W-�kj+��W'W��j���}�vE���J� '���N���+��W@V8��گ~v+߂�ji?�`E������qŏ��髖v#{w�dލ��2�vqG( l~�;Ba�.��MV�:���#6uC��jɻ��;�q2���w��3(���Zڍ����rG�����;�܍W�    ��n��;��
sG���],n�9��r�8y�B�� 'w���'ws���I�.�q�n6�N�f����/wG`�܍��8�w�(+Bsg7�yG��ލ.�8�w�w�����r7�|G��܍x��'w��w��]����>�����䮆rC�I�Q�8i7�|G�����;�sR���8i7�|G�����;�܍6���n����g��+|�T8����qNF��(���O*�D�I��(w�'�_a�,�-���i@�)҉��S$�F�)�u��ɺ�q�d��8E�a�q�d��8E�Ў�ɺ�q�d��8U�`���Tɲ�q��O��T��N�R��m�JU"�*Q�˔�Drh?Q���ٽ��wG`��΋�T,�*qX��Di�Q���n)ҷ@�)J4�6�H�:N���8uW}�#���L�;�sR���8E���qʮ�|G���Z�N�j�w8��5����|G���Z���{7s�� 'w��;��n6���*�w8�[uG�����w8)��q�EA�)��,w�'F��)���S��:N�"Z��Ie���I��C�)RD�HQVt��[MsG���=w8����g��It���'vC@ǩ�Y=w�8�^��S���Jg:N��Mt���7xG��#��8U�a�q�n�R��h�]�rn��T�̢y��?I3�Rw3Q�pr7����vӗ���|G���E��R�3�!�*~�
JUN�%���8l(U9qQ�r�0��TůfxF�ʍ���*>-�JU�(����h?Q����T%�6����ऒYD;�R��Z����?Ж�T%��0�*y �m*Uɠ�EN�J>�DJ��L�!$礄 'w3Q�pRɰ�mS�J��Q�*yb��*U�U��V����w�rf���dXu�qv��n�8u7;����T~��8��w8���|G�����w�'�gpN*v�=f.�N�Vp�|�T��:�n���n�M��dɲ�q�r��P��ݟ�I%+�?�,���8Y��q�t�E�ɒ_���%�'K�t�,�q�q�t�B���]'K�=:NVb��.Y���»d%&F�=
'+���S/Yɏ�j�J~T�z%��{=��zE��^���hu��Qt���8��ӽG�q���(:N�z)���8J���%K>���HQ5�Ǒ�I�Ǒ�(�Ǒ|9t�,��^�#��^��d�t�Ǒn�^�#��^�#���G��x=�t��z���8R���q5�!%��G���*(�@�Z��
� �>�oY�<�/8y�F-�I���� �Ƀ�؂������'��<P��'�msA��q�Nd�/�`D�r0b�9q���.�qʁ��!z��It�r��,��8yA�y��S$V��rA������T���q��N������v� �Ƀ�� '��N�Q���,�Ǒ�,�Ǒ�,��98����N���>��#x=΁O� ���|A����N�P8ypKZ���MmA�[�p��kApN*������#�O*�F���z��A�ނ�?yP�� �OԀ,�q���8=w�����;�Aeӂ '���#��sP� �O�-.�uj�<��]�'�@��(��z��,��}� �kA`�<�,Z8���#x=�A�ق 'rQ礄��}PK� �ɃZ��8�=U6���D[G� l���8�=����y��fE0NnO��!��lO:�#�öe��m�Z�;̊�A���V8��ʭpr?һ"��}�}EpN*�F�ٞ4tC@�ٞvtG���w�N���V8�S[��~�|E���yA+�sR�nt��s_�來�"�>y��p��lO��#���L�N�g��pr?�lE���9Z+�ܿ��pr?�bEpN��z� '�c�+�܏W/�8�SD�pr_;X��~�"'������
�"�?)�8��ۯpr߷_��қ��������W8�[\���]������ '�c�+�܏.�pr_;X|����܏x�pr_�Y�q������~�{E����N�+�+�sR�Mt�����pr?^�"��}]oE�}R�d�[�d��[�d��[�$:NߏO�~vK�`�ҷ@��?��3$�D��:� ���3(���3$F��ɇA����3$ϼ8'��gH>:ΐ<st�!�Q�8C��q��ۣ�ɇA��-	gH�:ΐ�jt�!���9��0��I�|���M��>�e���#E��G��3$�gH7t�!DYi��3H���I��'��@W���́r?{aApg_)^���OJ���I������+w��܃�;�~�Ê '�s0V�b����-.�8c����g?fE���j����T�&:ΐ�Y�8c����>����"�ޭ؅�8��+�sR���8���+���T_��#0*����i�"�?)�I���J��u�=��-!������9)�:������"����+�q�	J��?�dSn��)7���Ӕ�C@�i�]/x_5ŗ�8M9�:NS�r�)�̀�Ӕ{w@�i�?�q��ˡ�4���8M�:NS<�����?��4%N\���Ͳ $礄 '�8L@�i��=��4���q���8M��t��Ă:NS�!9'%�I%��q�
��I	NJ�d��[�$:NS�0�)����Ӕ���I���jJ,(x_5!�՜ ��I�9:NU�I�*у��S��\@ǩ�M�J�t�*�7}>�t�-�;Z9�}>�r��8U���T%�/��T!C�ऐ%npR�08�DCuR��Jd/T��(vQ����:NUb��*���|������8�]4��-|����߻�_�g�b�8U�ۇ�wź�q�@�i'�q�tn��4�A�i����$�I^:N�Nt�&y �8M�Mt�&y �8M�@�q�䁠�4��F�i����$�I�:N�������:�#���(�^�zŏ���(~T�zŏ���(~TD�i��/�`��u%F�q�rvGt��xb1�٭p�uŇ���(��:�P[m�I�[�٭p2x�\��J�a�-��}�!]1��_sE� l�0�}��F( l��¾��"4�w�����ì�mV/��¶e��mV�pr�#]��~�sE�����+���Z�"������ '���W8��AbE�������'�w�N�w�X��~�Ê '���N�WF�pr�
uE����@V8���"��}�yE������`�X��>�����5��y_�^�3d��Px�
���y?�aEh (�2O��}rE (�\tN*��yd5��7W8��\���}sEpRz����N�灬��Q��}r���"�>����ٽ�\�'��+g��}sE��ޏx��OJo�9�촉�{�׊ '��+�܏��pr?� d8����\o�����!�b�?�s�H卐@�f���A�fԊP@ض����m+Ba�k.�mF��mV/�Cض�!¾u�pr���"8'��bA����[���(�x�K|E���5�+�ܯ!]��~��� '��P�
'�;�pr?wqE�����+��φ]����φ]��~6� '��aW8����"���l�����,�N�gîpr?;zEpN*�prן,��0"O8��>����pG���}�pr���N���\h�o��&'�pr���N�v�#�W�T=�����������?���3���O_������n��Gn)��g[�Fw���������|���>��﬏�����z�aG�|�q�>���������w�a
��ÿ"|?�w	��s�Q�G9��z��(�?^��9��壘�x}b�����������?����W֟�T�Q�u����|��z������Q~w�>���������x}ze��������q ��͏������z��w���?�]���?���!�9�����𯟟��	�W������w����9�2����#:ͨ���D��q���s�����W|�;��'    �?�'���	�s���\���?�'���	��
����Q�_9�O�UX��;�?��������¿rο
��9�*�+��k��J;���w����~q���o8�/v��8^��7��oֻ�w�?*�.��QWǀ�����:�/5u��8^��~?����ם��ÿ�?��Oy��O����'����'���d�j���o3~�>����������_�Y�u~������o��v��=���������z�_ܻ?���o�g]_��l�����S/������{���z��������^��[��}}c���u_�Y��j�G{���zs=rػ���֟�?��=���������������?�E��ÿ���}=�ۋ�֣�oƯ����^���>�����>��|�����������^������������|�6����}������8���O�o/~r_��'����������C���?�`�a/�r_������g�ۋ?����:^�������������������Ͽ_f�����'�ߙ�/��?�������b�9��Oc/�����_�_>�~��w��'��	�G����~�����W�{����
���T���_}�;�~���_ju�	���߹�T�������C�Y��ο��ߜ�߿�����}�����|�;���������]����z���?�����h�O�t�'�_:��?=����?�^���>�������s����s����|�E�H����������z􏴧?��֟��#�����'���7���G��w����������^��}=��������W�p_���Wq_����5��c���o���3�hl�1�Fc����[�?���c�1ƾ����;��G<�?16������������߹��H&[n��q/��������ÿ!|?�7��?��{���?�^��}=�;ׯ�a����߹��h[ο���cƻ��s�E�w~�g���?�����b����G����SF��s�C�����=��s�C����GF^��s�K~�
���wn��_a=�;�5�?��Q������$�o�$���#	��I�?��H��F�G9��7�?ҹ�Ш����C�G:�/hcl�����s��Q�����F�G:׿�h������F�G:׿�)��?�?�p��#��_��<�ۨ�H�����H��3��������W�p_���Q����9����y�OX����?�����࿢$�E�H������R����9��������?����������v��<����q��\�8�?o���7�?������^��m��{�����o�~����w���?�y�Es�����*9	�K�$�/�?��D�HB��#��/��y��C9��/r��y��1K9��?0�)�s��QS9���������~��>�;����<�����o~��oG�H������ۃ����#��{p�	���y�{G�H��YG�H��ww��\������#����#���=:��Ϗ��/��s������ �?�?�۟���>�������y����q?���Ϻ������y����!�����?���O8�]���?��?Ǘ���P���_��'_�_���{�}�?����n����Uw���?�@+���#X�彡�*/�S�V}yϲG����o=�Ō��Ӳ�3X�Y��!���~]�`1��),�}z
�x�����<į��!�}�|�x����>=dC�-�-���>=�	�k�9���C�f�
��U?���̞Tπ�� ��6��=�g�g������7;�] �C�3`q�k{,��mπ����2��=Vg��g�����X�����#`��m���G�3`q6~,���π��J��2�
?Vg��g����� X$s��w�������~�~��篿w�����_������;Jc�������&����1;�?6�����0{�?g��g����X�-�+�?�3`u6�}����π�����1��	�q]���3`av�,���π�ه��<�R?Vf��g��lW�X�����s��3`cve}�G������z�g6���{�C��|�S?3϶�π�{?Vg��g���^�X��$����#`>$�)C��A�C��� �?�f/�g��l��X�]����e�3`m�O~��f�π��Y��t�6�π�9s��8@?��4�g���X�sb��sh�3`mN�y��q2π�9[�0�L�<�Ծg����X����s8�3`eN�|�α�π�9C��>j>6�t�G��5Gm>���g��"�X����JJ�XEI���*)?`5%%����d��5���;r�CR�@N>O��+*)?`%%%����d��U��������VSR2~��JJ�XCIɸc�KI��+()?`E%%����d�������ʫnT�������{y}ՍO��+	W��X���_I��ޱ�+	��y�B4��^QЈ�X�EO�g��+
��;V~E!�w�*/�>=�U_�zޟ��w,�^���c7�G���;�3X�U�&�?}��o��o��?}���~������_�?���L=��`{9w�M�l��gH�W���>~S��y����$�o�~ZO�F��$�o�~Z���?"D��*�`c>�`��i�	�M�g�ެ}��mt!���#֏�����[��//o�s����������V:����[��/o�s�>\/o�t�>�������Vb����F�O���F�O���F�O���Fڧ��o��˧��o����z��������wn��mtA���mtA���mtA����w��"����i=����i��O���o�̧�ο����F���o�������>��4�b`�r~��˳%�3`e��{��f}π��9��>�>6fO�G��5<>f��g��l}�X�}8�{5~��	�π�9���6{G>�� �g�Ɯ���B8��>��9o��8��>��$�g����X�3z��s��3`mN�}��Q�π�9��0T1��>���g��l?�X����˳1�3`eN�{�Ζ�π��?��>�9>6fg�G��M�S����O��l`����n������C<�}N��ix���5>�g;�g������7J=���f��g��l��X����˳��3`evZ~�ζ�π��C��>�?6fw�G�樺�6�9��m�
h��?����������X��:��sp�3`mN�~�ϑ�π�9��	�p]s��3`aN>,�1�π�9��<�?��������X�sd��s��3`zƜBx�k~,���π�9���4�z?���g�ʜ��X�×�ks�3`}��~l�Ꮐ�k,���π�9J��4�?��ԓ�9��0�����>��<�k�f�����T2�n`�>�+����+"a�t�*�����	x���V}�N�>>����~ƑN��}s/����i��'0������<�msd��:�O`n��3��1�=t��3�!A&�	ǧ�Nٽ�����^�C[P�zj�-X�S�T�<���L�)��`�}'>��<d�Ž��,��9^��1g�=Ƒy\��	,�)�π�9��0�o��N[}��C���
z|�T��OI�Hx�k�����&�+>uy%t��5�[�C���T4��9n��2g�?V� �g�ڜJ�X�#��y�9.h��`\�I��L4��Tĥ�9���<�?���!�&���q}�'0���H��y�vx}�C�@����>�aO����S�%��x�I�p����{Am�^�z����T,�+TO;I� �B�!%R�"R@|H�������ч��6�����9EGz�Q�yA��>�a�=�?��t���G0a�е:�<��期���9��O:�����=��z��C�QO;����8\|(}n�C��CT�E�������hx    $:=��D��P��{��!��cJ�!E�/��!��/�����'�i����5ǈ?�L�g����X��ޟ��P��_��S�F��٦�	?tE��H��g^',����MM�!���
`z�7�vG������x�����е�T�!�#z��C����!@�M)�L�6�=�\�g������=������g�ʜ��{0�3`mNi�=2��1��?V��ğ{O���S޶k�O�\~���S�k�Om�^'�P ��2>���a��Pl�%�������T �넟
��&�P��G��S�h�~�R�u���]W8��	��O�̫$� �	?�f��U|(�Ε���R�g�*>�l�>�BD)s���R�|�͑'"J�s;D��T:k(v?�T7�(�Pʦ�DC�T��U,R�,�d�KQQʫ����Wc��^�A����#b��D�P�j��yU՗��V�o�VQ��6����'�"Z2F\��s��ȟ�vɬ��p�'w����c��k��(i��Q�7-����F|�°;���>RHCa�]Q�ڥ�]�P�H5E�Js���9�YD��E���rQ|^��v}\�����Pmڇ��YP}|��w��n�32XCD��E�n����.�*��r���.�*��r��O5|J�5�|���4�D�$#�D�"?���^����ۅ�Q��e���K��EFy�;f�)��/B�j����5���|䝆➪�����lN&��(m�Q�1�����>3�ND���.L}Q�|�ܭyN�Q�T��yp��{ ��%GL0g���(�]�<b�cʓ�w/���/�gh�]��"{y�C��7▥#nY�7�UT;B�bТ���|��3�ߨ�]�n���P�n�}W~/p��|�!Pm��-���(p�������P�2ҡZDaߕ����U��+�%{�p.�k�g����*���0R��(�; 	��0��0���}�oO2^����G,y.���6�ݗ���������u_�^�S���ks�}yym���/���x����9ﾼ�6�ݗ�4�G���>�8A����>��3F-�� 8�/��X�G���ї�����+�2�X�UQ���B�W?��FG�s���;�3��o}��9WDyQ�|'"J�StE���Z!�G�M���{�ʟQ|��Daf�����P�־s�K(�i��)�
�������l�����%�ʙ,(�3c��bGT%���T6��f���9N@ U��������s���m��q���Hh���@6�=����̉
BAz8��C� �B��i�[,��8���� '�>�8���ł '�������Nf�=��(�
8YFU�'������5��
'+���{��a��Y�dPU��%}8�ϋ�9)��?�����������߆����5�}�;�߮����e�"}�n�C�o�s��-�pQ�=�!ڷ��9ğo���a����>�]�)�q�E|F��}��fkv�0����T�۵þ�fn�����m���S��x*Z�p�f�&��&�}�Ӥ��p�j�v8O5��oE���T�O��T��r�S��.<�N�r9O���\�4��S����<�Η¥�E����,�\�S�}��}۷N��>&~m!tO����M)l�WnJa���"pS
�w��oJ�w��#J�w��oJ۷��o��7���Rގ����d� ]�'�>����N�}F-p���ł�%�W�ɴϨN�}F-p2�3jA��Ib����\Q����z�srE0N^��\⫌�x�x����"d��6�W��3H��3kEh l3jE� l�zE���v� �]�Q��9��jе�_��~�E�����N�G�W8��_���.�"��Kz�O*_�$2$� ��GQ�;vS8�	e�F"�Y@���b�AWQ�D��� '�=�N���jе�a�������>��̭������g�b���I���j�"�I�B��}�N������N���+����V����� �?��-��N��-�����]nAh �zA� H������.�#���nIB A�����N� ���$�"��B�=(_�d�&�&��`�]:�]P2�n����h{�� '��+�sr��\���� ��&�8�ۤ�UŲ��hUzp�*�I�p��׬�sRx���}Rz8y��.p�
�C����uW
8[����]��9)}M8Y���߻��P��5�8+:ε�5W��}�X�'�w�r�+w�}>��q���"��{�+��q���J�&w���O�p�n{ :εf�p������7�l��aA��m�.8���� 'ۦu�����F��m�6�prw��#��ݳ�� 'w}����t�qڦm�|��|��d�!�r�?���_������f���~���F�o�l�uG��Q��}A�F�i-֯a4��O�������_�`��f�0��?�p�k���+�FC��3��3Ưa�����B~�;҉���щ�ֻ�i\�+���b�_à��;"�[G�y��_��.t�;E��~����0��?o��k�+�ݔ.`?o��kv���{ݯA�`Y|
64����E��y�_���^<f�H�"(?a�n���=~�ɪ(?a+�	�<а��Py	����7}B�����ܺ�����n��;��'���m����u?!�ɭ��Opr������=�� '�rO>!�ɭܓOpr+��G�'�rO>!�ɭ�'8��I�	Nne�}B��[��|��~��R<>!��-����R~>!��-��G�'��Odo�C9B�>���~xo��{l���,�}N���է?�A��og�����p�h������g�|�������h����_i���J�Z�:�ˋ����������W�˫C��e�����W�]������W��˓��%������W�����Q�����?��H��ܖ�=^o�z]��L�/������:�jr�`z�C�??�9F��k8��?e �8D�� J�H��Ɗ�ƊA��O��;;�����������?�1���ۯ�������6E����3�GG�Y-�B�W���;�w����?������!����z�������!���O#��!O����a��#��ǯ�l���������������Q��#�D�^�^_�����'�f�'������/��L�׏�	�w���>�m����������u�c~t8��W"c�p̓�
N!��p�-���K0��7�w�&
}~��W�۞����;��T}uj�6bP�>�U�keP
�X���]��_�e�_ls���X#��������`t<20{<Dw����ޢ��z��B��&s���l`�E�4l�`}��H5l���Kl/Zp�X�_t�V��g`�e�c��̿�B6BQ��f��Sx᪊`�I)_��*�o��mA%F	͏3s�[Pͼ�Ng�/�!����Dq�{W���(^7���mU�zr�E0�810���d*9;X��YT���0,���_��5���M~�%��d^�H2�lˆfU�_Y�[9�U���j0���m�v'?:�l��Ѱ���_}��a��n��|�U22���`��Q�{��� R�{42��K��ՙ%fXf�*�G�ß����~z����1(3,��ָ.j�^���q����;"����R��y?.��dX�Y��7,��Ev�<�Z�+��7,�+���{â�ް��y?���s���X���e޾���~���˼'ˠ�+ɴ/Ý�v��L�ʀ;�
�$Ӿ\7��J2���G�ݏ�L���=�";Y��C�d��kb�W�Y�=�ļ7������,�~�/��&�~��,~��+ˬ�S�C�9p*���xx�3AV�*󹘫%cw
�T֛g�Rj�UڇČhê���>�� u�*�����_E�}`��AQ*CU� c�T�~dS�,3�Dwq�f��Z�����L-��E������~a����Z�0'3���Ѹ%3��@��9Uݡi��Nh�U�}����B�F�    y�g�������o���t2���u����vv�`��:��#91��d��h�G"���&5ګ���W�������xQd�x�q>�+Q �D��X��WS�Cq��h_W)C,��JYۭ����*e�� ���L��Ǭ�.36��Ǩ�e�&�� �_]fli��t���������e�foV���S�A�q�r�Tpк����^C�#c��2���a�א�o����!�X{� ��<3Q�k������א`\������4�9�R.�Fu_�kT.�Ƙ��*�j�7U�]�T#H��@+/�*�{H�+�.��H�&A��JE+�Qz�եZB2�v������p�Rs���|hfj
���0��eSm���/�^'������~��li�^?�J�f�4��lAS���
*�*��T���yU=��f�:�*�X��#zlUR��y+C�UEUC+3��W�U��S�i��:��]Q٩J����oD��,���v���%˫�[��hY`M#ϋҲĚF��c��e�5_׼nP9-ˬ�Jӧ��ZZ�Ug���jYj�ר���d�վ�,P�/˭9�7�ق,��o� z�ɒk�d�f� ��9_s�˒����v�Ht}��Wۏ��L+Y{�� ���gMV_sIo4�Y��c��,��7yi�&k���:�LA�as}�6�&Nb��5���Rln�@m�d16���/(�AVc��́���Kz�PF��zl���HeE6��)l����&Ky�JeU6���U*�y���3�TVfmk��;Ɨ�E'�Ƙ8��U���F3K����d(�1[��^�^�R��ˊ�	m��-ȚoI��lAV}Ipwˢ�����ft�>���K��D3[��_r����#���\s�eJ���������9� \�O����#+��^�I��)��5p�g�ʦP)�ͧ��h������Um�a��U�Z��ѫ�%�Am��1�U��=�3�8V�:�'@c��l	�
�K*k���g� ������
���2m��+P,k˴p���LA�i�5��lAV�i�7ߛق�/�0���AV�kL�d�ق,1Wo)�ق�1���LA֘k���GF�"sMe��2IV�k��_j� ��5Gϰ'�$�:s-�M43Yi�ţ��FYi�5LK`��,5�:�
�隲�\k��%�bsm��G�^y��\{�I��FF�����\����mYm�#{:r6�jsS	��d��]3�ڷ%YmnW��� }oT[hW�v������&@�-SV�[�u6E�^QV���l�Bc����b�{ꂬ6��nL�'-���]��/e���0���R�!""��v��n�$���r�XHć���VfVH�}���V�MU�ق�7ەm2�>	��������"�B�^�Q�e����[rrɺik3B�%��G�Q��Qd,�����d���0C��e�����mf	����+�k��X�9�uMKऑu�n�f��ؕd��_�D���S�:���� D�e��]������Lq��.��%���ܫ��}�6ht�U-�'�Y�FwX� y�7���fk���)�=Ϛ�H{9Y��%N� ���_/���)���k~������G��C��z���)m���ޮ�	&����fYSD����n�7�n� ���Z���H��z�^��d��.'��E��_3V�A��_���h� ��
�OjO(�o#�d��?��w43Y���dC��j#��0C�ſ1�#�����t�����������U�H]�,��^9A�����(azn4�ſQ�Tc�Te�o�^�{3S�տQ�}S�����:� �#_��;����(�uD���.�,׍��D3��r�]%=���Q��ƻ�Yb���:�<P���e���t�73Y���횿��)�u�G3S��:����2�)hj]���<�� 5����_�.WS�@�ӯ:�Y��ցg�8�ijh�"O���:G�^0�hj���m�K��@�Q���&�9Z��QX����~�����:Њ��	�IS�l�:Mf^IS���I#��dS�o���J�Z�h3�L�䤩u����
��4���ﭽ���9ڴ�Tkb������x%M�s�:���4��2��)oN�X�hu�㆙4y�Y�@��k�nȝ�ݨr�y,�#�%hꚣ�R�d����k���I�,AS�m\� f
��ڌ[���4q���ܟ�Y�&��m��k��B��5G{{4vuN���h�#t.I������k���V��hm���F��)ػ��)D�a���LA+�t�)��l������4��lA+�t�:�B1[�4NG{��6��i���'��ق�q:�t�����#:ؘ)f
��Zq-�-i��#:���\��+ӭ�ya+f
��Z��x҄DG+q��)hB��u�4N�LAAka����&$:Z	�LA+�t���%z[k��u��قV0�h�U�DkM2u�1�*t��4Sо�6Z\˦0j��f��I��6��G�kM25�|�y���Z�L�έ�^ךd�h��lf
�d
ZHs�mf
�d�hs�Z��}�$S��u���4�������'M2u�:�����I����Q�F�w�rJi2���-ؾ��B7[�4SG^>��ق�����-��4���ʘ��4��Ѧ���4���نf�����V��w3M4u�^�'5S�TS��,�O�LASM�OS�f
�j
�l#�0������Ha�K�h�h}�F������w�f�%h����ß�LAM�ϡn�LAMA�-���)h���e�)"-2i%���g�N�����Vf���&�:X��|�)h���͞�b�J^�)xV�9q��ɜ�6g���LA�9m��˗��&s�C�_�LA�9˻?����$�%�)_L�����/�_����|of��X����L&��Ē�{ �ق,&�\�,�njI��J��4�.�,+v惼i~eY�3�ƅ��+ˊ����l��eŮ��~o�eŮԙ�m?ϲbW����ɲbW���}���+ˊ]i�T��7˂������W���=������:G��9Q�!0���d���9���(Y���D���f����L���A��h��,A��F�-��f�ʲ�GY�D3S��?��ݰ������>��h��e��<�9e�lA��ȉ�i�-���If���+��-�-�������$�U�3�>�LA��y펖�T�/�F�?B6SP�?Cku�!6SP�?��.sz�*�ٿH�%�������W�*AK3U�v�Y+qt4O���AU&�=�9�!��d@���0KP��p�)+�S�ʪ2ihe~R�QfU�4�1�v@gU�v�K�%�ʤ����f�Ue�Q�s����YU&�UǼ�3U�W�=ksa��l��L��-��d�z~�R�UK4��Ř�ق*&�����f����5��g;R�*&���@�EV�����U�T1����+�-�bb���+�-�bb08�r5[P�DC��re�����P=�!��U1���dH3[P���t��ق*&Z���T1�q��!1]Y���k�63UK4�2}F,�Z��� gȲ�%���7���YV�DC����*�*&Z��Y��,�B�Ӱ������V���y˪�hh}�t��������2�l�yV�DC{�ق��Z�N�tlɪ�g׿���f��ghs���U���f,ն�������F�����y�y0w\�n�f��<�<�r7�m��0KP�DCk^�fV��9 �,A-Oz�%h���v�Y�*M���]�U�4��7�?�*MZ˓�f
�4b�<6[.�U�4��av̬�`Z�lA��1����"Y�Mm�M}VeSC���#�gU65��[�Y�M3���-��)>o�hfjf�5�ߛق*�N^.�lA-�4�[�}!������͂�b��J��ܳ�}mQ%�G�|�UTI�в_�K(��J�������UTI7�+�݃bݢj�������UTM��f���EuC
��J�^Eu-��f����!���b�HQU]���o�lAUu-O�D�U�5��{3[PUݐ����TQ��R��f�����V�`pQEݐ�5��h������=��$3U���I�d�����6K��ZTQ7�z�j��j�����f	��kd��x2K�5��<����"K��%O    )�,A�tS�i~Q�Y�M��$\T�"k��'�N�l� k����e�Y�M�R6K�E�4Ҽzd3Y�eJ���LAu3ں��)Ȫn��g3[�U���E��"�������dU�2��M�dU7����Y��ޒ���dQ׮���+f
����aW���,�f�B��3Y�e���f
��� R'o1S�E]��_j�����\�����)�����[�d�8���S�f
�D�[��`.�D<�u2��,����V�d�8wF\�f� Ĺ��uY ����\�"�y\ӹ�f	�@�G��[5K��<f�bNy�b��N+mf	�@l7>�&��Y �k�t�ق���ŕ���d����.�lAV��	o�+�-�
q!��hf�BlΤ�l"�Y!.�N��)��y1e~R3Y .��d�xνeX���2ˇK7;��a;�.n?����.�ϗfv k�t���fv kͶgxËbׅ"k�e�7�)��lܟ�sC��5ü��f��f{��Y�ف,6ۯ���N�,6B�hf
��l&�Xe�)�b3����3Yl�o9��e�,6���G�9�E��%�2�d����W0[��f�Mg˜�"��5F����lA�k����e� ������d�������lA�k�I!���"��5�1�ق,6�w]��d����Wp�qYl�v����lA�k��bZ�Xd����[f��\ˌ02K��bs��б"��bs��/�9L�km���$�*��v�_j̕�f�v��l�\Yl�m�1�����\��se����3�*��ud��W�0Yl�c�ihJ\e�����O��UYln3񾢇�Zs��͈+k͍B%G3��Zs�3L*��,6�0o�AL��;��Z�*��-�1�AL�[,~;�b����VT�d���8�z1Ylny�ǫb���r��� &�ͭ�1�H�UV�[�Q� &����L7AL��[���(g�����L�&���rs�m:�(b���<�FqQ���6���oe�����*z�,6�s���������h�[Yl�4�u4�,6�k�Ĥ,��b�9�oj�����<c��d���9|����bs3���js�� ����js�Ż{T1Ym�{�!�*��6��h�\Ym�)��QQ�d�����75��js���se��N��7���js�ͳ*���6w;M�+���js�3)����zs��O4c��7�:�%EL֛{K��B�����^Q�d����JgE����c�|3��
q�e�!Hb�Bl���^�(�*��*�|6T1U!6��>��UU�#�|AS�x�k޲P�T��������
���?�W��ծ<�LAU�������
����LULU���gyWES5bCK>�����"���>���@�m�#UL��5��dP�T��������"q�/�|6�U%�tC�ULU�mY��b�Jg�IL��#��lHb�Dlhu�	Hb�Di�1�͌@��#{�ސ�T�8�\��Hb�Dlh�4�fF�J�qN��b�@�V�w�	����wCSbC��֌ �
�1��ц� �
ĆV]V@~��@lh��g3+P�z�ͬ@��w���f�@lh3�@�GU���b��T��&�m>�ف*�̃nb�@C��������)�-\��J��ֽ�E�s���n#��f7ʦJ��6Z5s�*��l��B~5Uҍ�|ԉV^M�t#׿�h��TI��fe>Y�M�t��G�o�_M�t-���x5Uҍl"n�lAU�"/�w�h��*O��=}��j��dh=�g3[P��SH�-��S$�ۿ��4Uy2����s5Uy��py��j��dh9�g3[P�'C��O����S���=WS�'CK������=Z���T�)��R8���ཁ�:���n7�Y�ޒ��n7��ق�.nM�������)��vC��p�MS��6���f
j����8]�l����㷆-��զ���O?�)���G�
#�n'�e~S��������lfjyWL�v4�5xO�,oǁ�69xoO�C��&�ӻ�mr�>��q<l����d.��!f_Mާ9	mr�>��c�1�&��S�s51�&��{�$&���}Ju��>l���)�����}������}�5�g3K�c�����f���}*�4mr�>��Amr�>��h�C���y�2mr�>�e�B�������f	r�>�e��f���}jy�_j� GﳝX���69z�Sv1mr�>��P0�&G��5�f�M����=�L������.��h����׮��&��s�hfr����Zl����\�<d�F��ϵ���h������X��69~���69~�[��lA��g�yn�f�M���fD�l����ܫ�lb�M���q]�lA��gF�9�ق�/�슂�v����J����B��l��j@	����P���f6�e5��޹���vY(�T�h�Հo]/��.�%]3�c��PR��`6�e5���-�j@IcF@�F�Z�K��2l��^�^� 6��
/C�b�]����8xH
�j�����b�hW+�mxrl��^��}�;�قZ�eh�3g�ѮVxŚ��o�hW+����f��VxŚ���h�u��G�hf��fΠ+��h�u�Zf26�e�������vYg�u���F����:kN��.�l�]^F��vYg��oک��.�l�͒zl��:[��͟�l��:[�3����V�>n��e�ͮEs?2�j�����[3KP+�mΓ�B�Z��u����
/C�6��/�s1�j�Wlavm�@�Z�ehŃohW�m��@�Z��!�f� k��]ʆ�v�����4y����R�ɘh�疯4ߛ���8�<��`�]V�[n���vYqnvם|3[��V�|6��.+έ���F��8�zyu6�eŹ���2l�ˊs�-N4�Yqnm�@�F��87sB&�ق�8���e�l�ˊs�[�|of��܌h�-Ȋs��4��.+�m���h��6�߰�.K�m�y-2���ܯ+O4�Yr�@��f6�e��.���F�,9�52�g3[�5g�����Ys��'�c�]֜�0�h��.k����`&�e��T���D�,9��^L�˚�93Ӊ6����������d����W0S�5g;<����l��[�a�]֜��|of
��l��!�h�5gc�ǡ1�.kν5���D��9ۛ�|hl�˚s�nf�]��{o�ء +�}\e��%Ȋsiƴ�Y��8�1;�`�]V���	1���<�4c�f�]ގƻw�e�y\cڼYh���,;G3K����vYqa����vYq1��ق�8ӕx~�Yq)x%
6:d�y|�)�"��8�w�ltȊ�X1�!�����M6������<�N?Ѳ�ɦP߷"3�!ζ��؛aY"��A��Y"-����d�x�w��Lt�����1��%���`f
�B<z�� ,t�
�7?��LAV����+,t��-�G3KP�t]�7"�B�*Z��%����6��,A��g�{�@lhs?�އ*ZsY{�@��4c�C�-�%{�@lh-�g3[P�t��q��@lhS ���*Z�+?TI���t3SP�dw�1?�����Zq���kh��0?T�*��`�CUa���~�*,��>P	��k���AA~�2��͹��PeXC�s�0��ʰ鲃�7r3��
��6�4�P�SC�b�Hf�p��w��c�©��g�?�*�Zm�-�©Xd��nj`��ﰓf��i
1L��6��ꦆ�6,ی���Z�LA�M���l3�n��<�Ȳ�h��)��^�U7M!ow�f4T���f�u���ꦆ�]�ck�n���8ߛق��Z� ([�PuSCk�B��6T�4����lA�M-�[�mmC�MmV8��U7M>����T���f{�PuSC�0�mC�MS�o�����ꦆ6�ۆ���T��ۆ��2��KX�ۆ*�R�糙-��i�a��bo�pjhe:���U8Mt.�_j{�P�uS|�lk�n�h��䵭m����5O�ck�n�b�&�Y�*�&���k3KPeSCk>��m��i�oa��m�����	f����Vg@�6��ʦ���f��ꦉ�,?�lc�n�(j���6��� �  �6���U6M��y��}m�����2�Y�*�Z��{�kC�M�=2&A�T�4�2�h��U65��llC�MS��{��Pe������m����u/�gg�l�(�v[��ͮЪ1�5f:䶷��\������j��y�����T{Ƚ{�[�T��.��B��-\�z��y��v8��Mb�6g��*��2s#��M5�r�yE�-��T�xNe����&
��w�[;�#9n�g���E���Y�8�`�쒭�b�����{w�UB�}�E�ogH�'H���X-�
����Z������Z�M,����Tli�#V���]���QX-�
�6��	o5$J��T焷%����	o5*
7=l�J'[��2�X��QX�Ζ���_��r}����El,WhK-�c�F[��x����VyI��*y�봥U6�#��r�o�Z��c�V[:�TLeO>��'�ܽ-����P�޿����x�dV~"z��s�c��Ɉ�-=��E�<f�p��Z�[�g%]�L\Z�|>;�8S���4C9��:̺׌��;���z�]�&"%���N3?U;��츖�Z�o��ߖ����F�v�LodDU3�,���o$��(O�vw�,Y���[u�db�S�G��D�&V3�	�����7�n7�8@�v���	�:	s���O��]����:�I�pߎ�
Wb������[�hf��~N������o�d�fO���U�y
.P���V�r�pS�[Nr���j�;j�jo��}�w�#��E�!E(�]ta���)�nA������do����P�fx�OͰi���5#��;2�}����X灜v�X�v���=�<[�f񖃷�j}�����n��%?y�d�OK]��_��������GR�c�*^�H�?�]'ӤF�ڲ���&�SH$Z �d�,K�Spna�T퐩��������{h8����.!!e����AJ�W˅ru|�I�͚I"M�)I9�������`�}��%�w�M|I�)K4W���Pi�]%�MQZ&�%[ǟ�4d�"6��+���QdZ@[/�6b�2�y�Ƕ��$�1���a��T�$��f�3�z�DB�T�T��JlRTi*�R��^31����ʓ��f�� ��M�j>��1��9����h=(܆o�r:ZJIcnY��8{C)#}�C��(��R�<�Q0��҆6�QpA�R贊�F��[�ҟ��P��&3\J60�4�?���(9M��A�7��S�s�����t^~�!�Zb:/?��Xn���y�yCja4x����$y�I"jJ?����_-���r�&���3}`G��V�Uj�j'�(��u}�M=s�2�W��{��kǼe�8VFz��{��	�hn�h����6ܤ���ژ�~��>���qc.8V���Q�3ll�߻yF4G{����y��6�\��g"In�P��y�J�:���#�ȶ�OH�|N�ޑJ���v�5�iR�����x��d�����BB��@<K��*8Gz��4���wșP��$��hq�M�&8M*/���s��;������y�ǅ�V$Ԣ�F�<��.��wӤhO�
HG����tc�:��.�]f�q��9�i�n�#\���&}�Y��lq ��+�Y��&�&aW��̷6tǂ?Q3Q���存��M�.dw[��L��C�P�dBx!�3���h�x;JBd�c'�N&��9��[oqVv6���-���f���=��]Lb/dsh������2         �   x�mO��@�o�p �C��!��b��DD�[XXFw5�v��V�̣��A%��r�!�'���ƃ��?�&Jf�RHIӯ�A@�V'�ݫc�я��>���M�I����UǷ�}�(hU�Ӽ�����Ŵ��;Z�����V]����~��/�iHD�         �   x����iC1�g{�,���,�֝%ä�t�&�zgp6���t=�B�  	��qn���K�ڽ����k��vx|��u]�֫����8AG��BV�U�R@� uc-[���#^,����J@qcAV�#��f�n˪� Z��X|��l�H��>6����ςM���`A>6]�y�B��1hZ�-�T�tW"|��v3Xv�'i���n��9�Fs>Y{��E�{Zb�Owf4         s   x����@��*� 	c���/@"%@D`�N�磅َ��p��[�h�ތ^���C�U�Z92�"j���/����*xF�{&��83E��^mu*w:�(�~��3�Q7         7   x�-��  �w\�Ù^��5Zm�R���kX�$X���r�)���. 
mD           x���[j�0E�G���jdɏ�t16m!��|�/���$�����Վz�4h%d$��9�
c�]��]�W<b��澾�X�x� V���֨<���X��>�6��q��s��<���[�J#)'�?����"��3��Tu��e%X�oÖ����>�$M�$-ϊQV��0Z���I*/��Rh�1
g}�~�p�p�'J�J��ÔZ�ֿ$r��3$����e�]��0�r�-	��K��X ���%WƘo�)         �   x����	�@�ϳUlQ��XLb<<�ɋ �����?9QDAP<����5�ZNp�S�.�p@�	�hx��5O�pՆ������ܿ"'"O�kNhP��4vXa9�"?�p��%��gB����_�#���A�������GՐ���,}g����_�R�vw4=�j�������o��M�//��ӓ�R����      	   �  x���[�� E�a���Bⵖ��l�ӝL۷�]��#8BOILIk��J�R�W!{�'�Wi��Au	-�ܜ3�=��T%�=:��&����J�Ϝ�F����钾�ؖX�8�Hy{o[��l�2����+�g�c�TGC�d��$��/��j�n4����X�ظ����$y�����o�%�t�7�3�t����h����:(����K{6П~�ޓmj��`�lwVzj ;�=�R�����t��� ���4��B�r�,�Z��C�������l�ܲ��`��Y��ۜ�N�X��{zaX:� �W%��v���(ܳK�h����?ܗ�l�{��|����`9���7�xO���U#��������/!�vgmQ:���3w�E�Vd�u�l��(X]U�����{z}o�2d%/�>�K�ۢ���ja�,����Vˢ�U����{��	��1���pe��V��Kѯ���� Y\V�u��L]�QԷh�|��h��'�trI�I[6+@sд��%-AW(�t�S�=��w��-�ރ�i�8i/�E >t�gQ��{���{<|�v�n�:;K�䇦{<�Σ���at
��R*g+��C*y�F����U ~n��׷�(�o����<���P�͕ { AՍ3��n�B�<�^�r��zGt��W1�c뵖Ѐx��k�~
2`V� 2`n�s�mPݙ[�Z��~TJ�����^�\v�����
(+��s���@e�p*�(�l���ns=`+�bԠ[2֡�l˶�!~[F2�+�Ac;�J8$���`�� x�U�Cn4O
��� �OQX�v�uI3�R[wz�f��{�_�~��5^�0��?�2��n�[�!����aw_�n���h����� ��a׿�@�ݛv@ېC�����]!�Jv��lt	��9?��B�#aW�<r�"r+��I�m%��G͓glm­���]���jkG�Y~�=K��ƥ��X�x�U���P��Ej���q���u�j�U�4���p�`�!׎��'��9�!-��\�)BmEw�(�5�6� ��ׂ���۰#��];�Bs�~�@�j���ju��ێuD�;y=�GU_�{��EJ���')�������E?�*S�1G)�x���_EB�H         #  x��W�n�F}�~��O�]rI�T�������)�p�l�8m�ȁ_t���(Q������Q�e��͕k���;{v.gƉc�y��E��D�	�O��%�x��E凲�׬�^<^Ie�i���F��)R٥*��S�:���|�)�Q�N(�x��A�N�3�kj�vf�/)����q�P��?H�5��I��Wj�r�Y1Rg��5l{�����On�	���=5hϥ=��:8Sj_�t]�T����]�{����=���%�v���~@ڧ���@����;U�iс�mw����k���h�F�z'�-�t�}bK�c|e�>��I_�(�t���G�z�y|y^�.����|���G_k��WS����0,L�p���-�`G��m_:8!N��!��>�k�S[��lr��~{��d�+c��b�=����Y1kz�`Ѿ��'j;�x	�T��4�N*�C a3�_q'"��Ӕ8#��B~��96{�y����7�ɁuO6�Ɛ]��L�5f��ל�eLs����(�H��,h{��C{��/;X��/ s;���-/�ik�#;��`�b�v�9
��L<�N1�>�Y�Jl�;٧��^Lk�:���� u�s9�q��7a�=�
�+�� �� �>ذɜ�) ���3��YR�n�	Q¸)	�(ǩu��h����-kr�̍��ǡ�'����Pa6�
Ug�,:K2ݥ�zlΞ튫m)>�ꉋ�����-*�� Gf/y�)��a��>�"y���xC<���S1I�YXX`�73�s�k��ϯ�)�T����Ł8d�|�s;lq5|���朔e$�_,�j�
�	���j@y��9B�~g��*��w�������e=6�P�x��4Ro#�Q��

<�L5-�qC»�!4����<]���.���o}��	V��c�Ka�E�Yt�'���b�p���iǻ�桦�0�sa�",��cS���rC�&��>y�veL�1A_��~;�km3U֙1%l7��oJ�AÁUc��qU�������(�WjR��ӛ�HW%�e�1ʟ�GF?�1W��#��C��+i�8���I�Mx)]D��6��pvE[pC]�dR��ٕ42\�DU~���
3V�6�#�����pg�qV���ˏ��7��&�O��:��E��'>�=Nj?����u�����!p���&9UR�L�ʞ� 냡�:΃_��������t��h�y��mdX��N�EטR��y�������ʏ?/�ܢ�iNo;>���R�_��1�            x�̽ێ-�q%���+�$=䔛��i����"��4Ū�&��� �� z�А��K��&h5@�Y൪����?����m�s	��xX<'O�
w7[nf���'�O��������������7����O�?��AH��;���iRw�>x����Zis�ҝv������D�;E�?�S�ژ�̿���a�����<}2}���{��_�?�������������i/�~\�������}܊�������ˀ�x����W4���(�Gu4��x��������3����i����~���*����n�n����7ڸ�WF��_VeO�{�h��!��@�dcF��g�㝎u�S���ʘT<�>f�N�e.�C2�����E�Qb:ظ	C���"���D�p�!�{K^ǌ�':��eȔ1��7��A�e,�z3G�<݇��w�C�珲-�!���+�|�]�����G��$�1�X�$�zz���o��k}��~o����$����&F�N�	[��kN��&6��(�;�o�c��<
��F;q�M��[�e�7q��kы��xi;Af#�'�s��M��&�71�&�N|�^o��bq�u�&̋ϢsR��s0Pb ����Z��S�#�k��r8��O?x����D�*4D\���+T	�P�;T��X�ҽ�
�G=G�1�QdxH9� s8@I~���+��C��0RL�0�u�q�9��e��5�6�c��C��Cx-�ϱ�:m3T~��?�o���@_���WM���3�K?�C�K��Ƚ�T���"����R�H���q��ؘ��'5��L^���'�1�cW�9���
?�x�6S���|�ڜ��p�&K*q����X�N�װl񮛌��KF����#W�<��gd��-y�1��퇒�.�_^�˔�Q�5�8L��
c6`��I�ueBY����Oߞ��w�/�/����o�>�y�\������w�����n6��qi@�N�=�>�׿����	�%{�rtz�P�p����	�ڠB�>�f�wT
���l������c-�*���Fն��C���8�P�f��P�C����|jU���0*S�rn�w�*�Q��P�|]�h[����Mk �1�������
���t��B		n�C��<B��f乔H&�UGcJJO-�����q�T�J��̓��۰t�J4/�:��lj7�7��X�qD�}u�n�1�����!o��︕}�/R�9@ێkM�1�M������q���\��e�_
�W�yo�09=�0��>�чH���A<�y�|��\�iP��9�������l�l������L�����נ�d=3��@�p8���1��\r�W'ȣ����I�gH�iA��$W�t��ڐ, Y��{L�#�}Er��7��$�"���8�N�}LmH�!Q�aR˘ʘ#x����/OX���}�\�+R5�h	�.������1�]�\��:�v�9���1'��s�L�r��*ұ7��X�N{�e�< �ԙ�l $_��{#E@b��ڐJ,/��8;�Ħ9HT�vxm��9$�M�7_�����u�|0���wl�>� Cx�M�7��C�����!<�r��ʁ!<���u�p�����79`Wm��cojB����Ǉ�H��!;����՛�;�	³u�=&`[��c�mC����'�{��!"�����!X\z�pU�H;��&~���k!K]��)̱����\zX����(u�E'�g��
e(S�I:^���O�PK!?�F�0`T�T�^���zy Sl��i�v�hY�`�Ư`� K0�
F��6�1* s���E0[���L��`�`�4�=���ABuj:���02`_�ڦ`�o/����r��V8�f$D�V��B ��P�gأ;�v��̘wc%أ������'1`�+��_�ۘĤ�3���d�`V,��kd˙��2n� �+,�7X�b�cy�����2��mYe 0��N�Y��|7P�L��v�UӨ<!�mս�tEu]�	,�5����c�	�{�H%6�޼HJV\�����c{��(0��H
ȉ9����a�r�JN��s+�Ur:��1�&b�v�K��n�%Y��,�e���r�G���_f΀8���u��D"��Ff�[=on�}}��4l:���1��e{���hò�GrԊ�a���O�X@�Y��leB�v��l+��e�ʹ��C�a؎��7��PR�5׳�{z^n!�Q�̡�ޯ���k����,i �#t^+`��bG�1L���%
�?��al��[�,ta]�0�f0������40-a|��z���"2��#2��3pE4숣{镲#}�!�R��)I�ۋ���d.5�w#��Q\c����ϧ_N?��h׼���g���XD�J�P�a��f�ٻ�<��*>��	o���M��~7�K����'���^��[�x-�6q�5��W�R�� ݟ�e�M�?��Vj��)��iE*'�]��� �}v�ã:�{}��\���6���m�t��Q욋�y��I�6^�����,����ETݗ-��փ=�Ͷ�����z>�'������x3�����oe��e���a�bؙ� 0`�Y����9��Va��:tŔ#�}�Dwa�r��y�z%#�sh+�x�<�֐�:�q�_,m���:S��7�Ms�Ρ���u}�o����քZy�WRn3��mÙj�e\sG�E�Hy+��
�Z������C��X��ۅ_G��yO��2�܊��"mZ�w E*��\*ϑ���tA�=(���1���<Fnr+��{�VM3�ǭ��m%�{�فQT��`û6��� TQ���7�=5S�U�yA�u��#��5m {�`���"�|j���4K�r�� )T�VJo�=�G��l��HT��Ĳ��!L��^W!�7��4Q)ݜϝ�/"MF��Aե�*ë�HQ�j~��dۑ ���?�������<��1��H|��j�s{�/�ܬ Ep^��ϋWa��r����n���R
;"�f0@�Kw9,�7�MaY�`���{��7G�`�JxGM��>�������_��=0�2Z�[{��lk�"`�:��/laaͱ���&}#)d[Jwe�Vĳ,j�i�ߑe�E!;��Gi���͒�bS�۾�h�Į^��ƳUk�
�h�t1w�h�ha��d��Fב���&ZE [Gf�o浛b0W�R�=Sn�,t�1�6R����V�Y|�ej�8۱;!��.[�HH,��Rj�H���}g�"9ؽ��J;��m_���@��X5�s>�		�W~�ݦ�τ���p��Ӳ'�_���8ҵ�s���tP=l��"*ԥ~W��^���ĺJn�P	H�:�g�]�1&���6� �h
W�P���_�X�f=Wϥ�0�XGu0*���]�J�s��Eb���ER�+1�h����sˁ9��D��*b��� F�~ g�h�b���s
�Edl�Z����&[��l��ҟ�l@9�\t��/�17
�� M�j���b�祡�&��ɫv>(�+��j���N}�l��$���) �acj7�6$N*�1ꍄфc�D�ٳ
��*�dn9C�UE���3����R�\E�:w�n���ܟ�#�Y �P�!�/R㐀 �<�{� B`H��j6�6]�� C�eX �X�����'�S��H�w�+��yh�Uv���l��ïiS渡��,pQd\�?�p�4_�r�� d���7Nv�l�����S�m�/j�mw�#�!�֐��C�CjSEx"�g�י�������c�Q;w�ĳ=�h2=QD���;��!0�h�W�M"ըҶ2Q�2C��dbo$��P��4E{��"B5r׺�"�"|`��ζ�Q����]� ��@��{LFb��>�M L4X֞�5	C���c�Zr� <���\0�,��[Hlgw���aR�!E!�f;Fg � ,��7����&����=9B%²�< �Tò�Q�jD�	�*�f ��    �� 0��Ķ��_���,�������E�J���9�H
��]���4�D�T�������Ŷw�*@bY��m�, Y6{�-J��9�8�j�=cbYh�h�8G$��io*�9�c�ld{'���uN���Ќ#�N�� Gh���]�H��qD�Z�Q��qDk9�	9�1�؉�a�FA4Y�fFE(b�{�x�(8�`գ������("�(��ٱQp��X��E��[1�!(K$v���{��,�X
�z�ߌ����z��;Xke�F#' �6��c��!!A���5\ic׾	�!!X �z��J�!�b4�J��HB(���/7!i�KDv�#�k)������5uj���r�Śp�6G��Q�}{���ȴ��� �Y_�c��-�G�K�heO�{������Ui�L`F�N���\Ŗ��Z'�^�1W��,V03 ,r�l��4�?�6��r�[��s�f������:��c�].�2lX�ct��QM����H/cd燭%��aA-3�Rz炕1Y�Rzo~�e����Ytb@z#�r:�<�A�0�s�ͯu�2@�m%��W����EН�E��
�Z�E��ѳ��o c1�`ű��jϐ �P���zsL�������<l��K��o�_.cbH����u�D��󑊱H��iGY�iL��rA����9&T�H���U�؞bH��i`.HT�z���#���7��#X,��P���2��}����H�Kb��ma�Sy�KbJ�s���(P���d7 �$&�9��hh@�I��Y��@���-���"��s�����D3\e�N�A_��3�!��	�⾠�$��?��-V"Lb��S�j�x��O�mk�*m�����	�I���v�m2���PO:N�.۴F��$v�����^@�v��sgxi��k0*`�ҳ ���+K����1����}u~Ę��έ�X+F�GB���	���.P�9 h]��l����`ۨ�-,���zLbW�κ�%ZLb��λnb�z��nO���[��~��6( 
v��ܮBo�	'�rj/U�}_[6)�yr{\�6>�U=9���`@�I�zǩ=xn�1�'�@�v�m��A�Y>��"5�p�[b��y����� [P����;�	����xi��fH���c�b�#�n)l�3�73��˄Q	0�*��,h1�'��H���[�C�=&�U7����-h1�uB
MY�$�ƚ;����,h1IEf{]/�Y�b�/����eM�.hA�IL!y>w�DnV'Xqq_r�/n���$�i�Ԯ5m��-a8Q��7@���$���~T�T�Y����������&�Qf��Q����O�Lb��N���NH�}&����[+P�L��3b+P{ �D�*Q�����&�Z��@@Z3��c+L�v��WTm������}�rP�|��g��)���>]����Uٍ޼V[��j��=P���^2��̧�8����F��P>��(��"|D��3���O2K���?M_̬�����G���s�O�����&��~���P`/�����ʷ���y��E��<����'Oߝ~3��U~��x�j�ӗ�������O�G~��d�����ko��B}����/�f	�,�7�/�f��s}�T�l�y�y3�oV���f��LÛ���N��Kϙ�7���_��,��Y��^z5���sv��sƙ�����b���[����3�����8{��-�`Ϟ�I�B���ݩ�ʁ�PNi�Ϧ��Wʯ��BZ�a���ms�� ���Q���n5��c��2v`��e�2��4S�ζ����h~A��6 ���������z c|����n�0�*d�&�x��Q�{`W��ա܎�٢P�Ռ�_f��D37#�d�������р,43��`;��ڝF���gh#������̓�P�R\06[<�-%����A�ߑ��$ �.�)�>��c�K�����Ũ��4��}O�r�w��n������`��/�嫫�����Lw�Z���u�O/���F|��; �y�,vR��G�3��U�K慖��*�����:��l�5��h@}�QߎM=��E�5�xmGLӎ��X
���Ӑ"��c��#���B�k���[��B@}�QߎÂ�/�hY`�B�vّŎ/D���2v�Q�n�i�
��ѿ�� �ZF�n�f��*�tD&!�2[;��d'8���\���x0)��؈t5q�ԑ�H/�0�&u��v�]_���vx��.x!v$�#���B^��vx��?%x�J��e�~��;�@�N�Uj;R�v4d��q���l�W�������Dd��2�(�@����qG%r�T�,k��Y��n�N�,k-(�9۱�y3Y�Z{-���o�����l��m% ���	��4�O�����>D �
L�#{�f@с��(����4]�v�q�h(u5m��:f�Q��8uG�1��4g.�VaN;�C�+�!�T5�;�9�P�S59�/S�s�G��Hr�4��;������EŒ��0"��:�h ̞I���/#�s��.=���B/B�Ȅ^;� ����b޸#m7	\�v�l��.�1Z��eJ��@�k�|�h$��+V�S�o�NTw�fk�B^՝T��P9��o�U~�� yx�]���2�a�uY����^X7��EG��+��8���B�ǑH_���Y,���㘮/�4\���0�v�����i�=Z�-/�G�ӱ��A�C�+�| ����;ӗO���-�U<<7�W�V�1�p�=]�d�M�w_�u���`�=�5l�E �,u�CἺ�]�S��p���T�s�^;O4��f��M�w�n�1K����K��E���!���`��ˡ��/Ժ���憭yk�_/�=�^f�P��5�=k�=z����C��wz���(?�Zp3;N`��9p�c-��.k�ɹO��v���σ�z�]�8�nG�Vo��J�1�������+�y3��d�=�X�h��C��p~�S�y�g�>���#��f�\l�ܱG�y3�\A�9��N�}d̵C2f��"c��[���G�%/���1���wv��Ƽ0Ad��,4��t����||����+�ߤ4&=d����Gw�Auu��c6:(y8��y��zB�S�r_��0^co���c<��ofv�Y3Áy��v� ������vv��"�d�s�vjGK��L@�c�@���4����#>8rT3 ������@l��q�ԾBőa�0�O͎�chq�q�� ���.(���_���b|��0��L��Ǝ��f4�3U��ȗ=h��m�؀�T=_I#�TA�Ó���`�ɲ��0�� �R,[�qF8�� +e�!���f�}���{	z�(�e��;�Q�7=|��O��S_���iG-���ƧӀ:�逯1�鴣�ێ�i��N������V��I8��5^?�w\�hG����鼣>Վ5S=�~�.Ҏ\Rs��i˵���(�t��B+8_s��yD���h�%#r�*Wr�����ʕ\�Z� ���r^3.�q��>��%�r���X�����FX	p��'��#rt�qI����ø$2`��1�%����<6�����_8�y���o~�K�]�pS��C�n3k���of�7��N�by��~0�i}9]�%�fCx�=6ϓ��U���	��F��ԏ/|S�C�?�X��·M=�
t���/}X}]b[��<� t�m�/}4
�8�XH�҇rn5W������ThO��w�aZe�d{.�`{ǁ���b��4t���[�z�8u�aj;����	I;��q߈?����1��qԈ`;`r�xg@�h�K<��	`D	�f���`�������Ǳ���{&�>w�{h��]%���"�w�=4��r������W��w��cw���N{�ס=�X4�ֲ���Ƞ��gMoN�GRx_���i02'Xk���#�l���KB��u�y8�s� W���}>Ʋ��(M��>0
!^Bq<�	C#�^P�z�� �[@q<    �	�_�Cf��'��0 ( 3֪�^�ZP��>f�_�Z@����,�K�(���TwN�ڷl�}���{g��gz�yS���P���Ԡ�~�1W���m�;��v4��X$�2����;-�m�R߲�|G���1�c�����}wr@s�-sڗ�]�?޻�
�|o؎�~��eY��;
��h@Y����/C���v�h���e)ba;�c)W ��w��\�\+h�͖m f��&ѿ�E��#,<:���<¦�e�i���rsJ���.�di|��~T^H�9�����w�.G��7��ͣ�8�e��~~7L?�~5�!���+�<�ſ}5�r��_��0�a}	�%ѡ/q�z-/�l}	���������|	���>�/!hlBU�p��/a�Kd_g"	����H�%��Kx�D�;]4�LT��Np&�"_Z.'� FEw�3��˧Qg
7o�/�h�"�pw�����?�~>�d�����g�D����~���5�Ĩ9�c�N��rv�`�d'��X�a�{�}b��^���
��݅{��,?�
��	�
6o���,qK#������޺7���윿��,p0�V0�/#>X]�9$���Ϫ��~@5n5��5� �6�`q�4`�Pd�:^o0`�*� k� �2� �� �M�k���� n� ��وi�u��3 ��:27`�"2��2���� ��J�J*M�ʙ��1�,��<�o �tE�;m�o�i "�����!���7�� �)�{#Y>{�Ξ?�Fr�NfE���aL�w�����:`A��z#E�c��7R�1��ӽ-")@���{�SB����|o$͑��j{�7���S���%��Pg�����p}5^"��1of�rC�VyO~Һq��iN���-V4�>h[c�����C)��7�=}�M�|�@��V�yS��8X~�:�cw����C5��i��V�^�N�����闯�L?�~2�s~��ײ�N:�[�:���P�K�i�u�~�Pb��Pg~�=�+Ŕ�q֎,C=Q{�����8�=��Ĩ<��
6bd�1d�5��8&��l�/ ��Jhn>&�F
�T]�`@)je���`�¨XG6��	D�:�~F� k�r�o�Z�xrnG[>�l���v���Yl$�T=W��+䤚^�4A�I��"z@t@�I�r�1����7�Z�%X���w�C<���ü��7\�rI���0�8�J+��#!��J/$$�"�Ň��� V�0� �ug^w�sh����Ә�k*�j��wy�������3lQ��q������k�`u��CG�/����>&���m�Yj�^� ާ��z;D�#���uDK��}�	��3�]�X�Y��V�X+��4W��ܒn�y�����t.)u��~3ıV��Xz��6r�h4�*؎k3 �+� f�T�� �p f+X02���a�����!q�*�{d�+؈5Q�q��,��B��"��:�Nm�A�r��n�F���+V�����f�<,�G���q�0��q}��[�5�>,�G�_h [�=�"{�q�Xk��{���� �IT6���4�V��X�-�w���G�X�AR�\X�9M
�=����L&�
6`sq���5��=B�M0����a�}(��8�Dk���tc�ࣆU�b8��Z:�`�$��h��=9�zv2C!y�
e�Ca��mc�����y'k��w��3�3�#���PkH����Y��j�Pw�
��R�P�6j�d��Y>�Eo���u�b���m�;<�;ji���u��!�X����a�����,�ӯ��iĹa~B.2X�F����_�F̮�}���z�iՑ�`���5��~�4Z �l�4: K� �` ���`���̧V��"��:��]`�	,Xu�9���ALY�7��i�� ���>?k0����1H0���Y��A� ?�� �2H`��U�����U�#�U?#��U����&��l��	���aA��Z�i�N��2+��5'3ƍX3`�����60`���0`U�8� Q���>"nQ���#FB5�?��Ƥ�A��ٱ��0�a�UI
�ꚝ��I��� z��1���٩��� �,O����A�f!��� I��òxa�� ��,��� I���x�g�u��gi��2RL#!��i<� �2Ȭ4kQ3<� �˚_��^�8C4�J����T)��7��V!%rɨ���\[oD*vh���h�e;�\���IjNJ��M@���E��K��J�eV,��J��<%�.i�k�`���`�b�����J�;�����vi8iX��x���:.���ڗ��,�|�eZ�`����[���?��|9V_>�Y�e����=��Ng]�1ޗ�R9$/|2�2��h�ܣ�u[�4�Q[a\�9�?���&�:�"X��`��	=a<�xs�& �e&�z�DXb�9��I`i�YZ�I�?�\'ͱI�i����
�YH�_c3���J\���^p������F��B���~�贿����KK��q.��E��p���K'��������|��VN�K+��D���LՑ�c�Yϱ2/^��c� +�q9�+Om�>N6X�`�\�;�X�N����r
�ܵ���ҹ��9,�b��鎥��9��Sw,�]�hߝ:<���ÿ�cA����F��5~���L�����_�/�>)-i�_�р<�9��.vo���1���+eH����g�ϧ_N?�����$�b,ü�4�&𺀫^��*�g��ȿ~�(0J��іoKu�P`S�̽k`��7� �R�+�B߁y���0�X��V׻��&l�)�N"�B�q�P�t9��L)�%g���\V�N��F+�|�;�h����hs���њ��VX�\�ь�R?��b�J��Pv6��,�f�0�;�[�=�����.������&^��"����{�@v�����|������6T��Ox������=}�,l�s���e�S&Qc��S��Z'Ƶb�{w�:�V��U`u\�����t�h���t�j4�)��ox(6��fGhV,]�e�Z䶕$�b��:b.Q��Ӟ-�	
�C�
uz�`ԀŶ�x��ӛ�-D������c�`#B�q�珨v������v��XP�0��rN���l�9��'��qǸ�L����:,j�j5��=��¯&��Ӹ��G(#ُ�<\�k~R��l-U"���>��#� ���O]q�T�;F�p�uM���y�:�M��{�N�G�PzO �aTu�C[
�*��P�}w�����M�{�g{�ܘ�Cb����Q�V
�)����Z)��c�S�Qh���b�^�?v��ݰNa��u
c�c��>�KƐ��0����WO�~���y�ō�VM���c�w���rh�����!��>&?G��P
�WXO��.��{�|FsS�w�,)�r+V<��X�t��?����������ױ>e@�_*,K�����&F�HB**��S��mTsi�F��5����ؿ�~?}�*?����ϧ?�/���~���ǧ������x�Ο��j�����j�yܜ}����Z��:�u���@c�����Q�)�����W3���"�t,o4�A��7q>��z2�Fް"�O7?��լ��Bk��0�(	����i�A�j�u�Qr�5�Z'Ih�%�L8IBs6��=��}�)�I��r��#51�v@�R|��XQ���U�u�3�w�
�ָ���ݱ"`Ŋ����V�Pk�e��2
��b-Ő�Xs��mܛ�sh �r5~�?�ׅFT9l���X��>��˕�$�{�gp�lu�dR�@�η��8��"��z�MZ�$����X@$�9��m��!���}o�;Aۨs�L���@$>�9���Z W��>Ro�@$6ԍ�w'c�����}r��������ZY?��H���e!�p�b���-,`�<�+�C���k��u>P��_��W8�U�x��m�����y3k�r|Ԓ���n�9������­q]9    �t����T<Ԥ��`��� ʐ�f��G�[fa�� ��%��7�������?�P���<r�+5&�(z7��:�]*"'X]�mH^��� �co���p����=����lǃ�[�lǃ!�g�}<������G�h���f_�t�{W����҆��kG��:�#����e b ���k���B�w����?L��|����W�o����篧/2M�����w���N���H�ᘴ���k�B���y	e(��
e��!��o{oP�ڼ����uι���6�ٱ�V��܌�h5��k��{�[nh@�&���K�%���a��K�Ԭ��=�4�|��cz�3��'6|tj�O��ቾ�"�x��w����z:�c�/�����g���gt���3��g�Lˇ�6�h٧ߌi��w�M����M6K�zu����lԙ��q��Hh+M��
���Mߟ~�w�O��o�������]�|�*��?ߛH��{S��w|>����H���o�E�ϟ�����1��������w�R6e�T��JE��?q��3[O$�^H�N�0���>C֚0~��>C��/�MY��LA�3v�rA�?�?�L�;nZ�/�?j���a�Q�Q�Ϩ>��gZ�z��3-���D������Ϗ,Kc>��>�����L/4
��`�O��=7X��5<���e�L�w�����8x�+�>Ӱ+l>1�;v�{���o>|�e��z��>cl�����t�),�L��r�1���X��~m�Ϙ��z��'v�gl�'v�B>:x�M��>��gb��v�����w�`�}�Ǩ�gB�v�3���8���g�L��3|�w��>�!6��3���x�t�G>�:̣�I�ǃϤ+>�:p��I���>Ӂ)<�L��D��a�L�	�Ϥ>p���3|&v� >;�L�ج�Z��t�]�L˹���gl����V�zV~��L�
R���,B>�r~��D�ہ�"����|�v`�>�z<|�t`��5��>�rr����L�����gZN�6��L�����g:D��p�:�ϴ�K6�>�{����2���5�f�_k��g��G+�g��=Z�ϸO�q�߹�B�y>�i>��fZ�>�|��
|�=�g4� �{��h���g}��Z����x����{n���:��3����'6p��<��5{}���v�<����^u �O�=��	���3v�!����W��e��?|���Yk��l��g:(L��頲�|�%C�|"�L����34qZ��t��i>��o>|��to��3-U��'�ϴ��n>|��:��D�
��AвnE |����6�3�u =�t �%ؚG�3-���g:�|��-: ��l��3-Q���gz�#� l��t ���ea�QF: ��ĭ�q��tP+j>Ӣ-�|"�L��q�32v�Le�v�u����3����>�Aî�L}���uЇk>�A�=�L��
ڃ�tЇk�Y}���3,|��)g!�9�L�M(���P/w���ܥ��w�ֳ,`X�ľ F�*@��p���+[]�������_x�T �@ ��)��q{۬�YQP|�!�����L #0E���@�`��KM�/ ��RF�
ѕ��iG� ��t3�������*]�55
f�w7{��z|��(�r�ݯ����_6���"ÝV{?,`����� ����^ Z��"��=���&`���7���o����8�5�p�k�b���fUAoA�ʼ-������0��;�����N�=�@�F����B�7c�.��b�%u�s����)P�`|E?�e޻�m�$s8�C2W����&�r����/?��siy�B�uvy����n�5|\�����KE��s�����Au{n����n��5?����๶��z��n��	���=��o�s� ��s/����wy�~h����:xn�����~v���!�s����w[����m~���6A��.��.�5��^��B�`ws��!�Yo�ݭ�����ﹰ��n�q os�v��f�E%��v��Ѥn��7���K�n�ao��8':��{�V#=�� �H�� @�������	��-�H
����&��t���/t��^�qg�=�t��{��7������K����j빰�~v{����s n��聸_����s��|���\�7��;[���{��s����/Jw*�\��/J�A���3�nQE�ş���mGEb��o��׷���{�z�c�y�?�������2��\�ߺ����~� ��~��B���OR��n=��n����T���nk(����u��5���b빸�u�/4V,��N���x���f����7Ս��o��׀��8��z.�ێ�ɭ炿5֒Z���[7�1�o;x}�� �������m,�[�n�����,�[�n�n�����'r;���y�����b�������n���VO��8	����d7�u�o�⇫���t���I7�E�I�n�o�[������/Pq���o�x';�/���'������Կ%�����7;]��C���n�:�?xX%���ivT��x���'ӯ�_O�>����x�ޫ�ׯ�?L_N���������˧o?}�?j����ӏ����뷯|���w���/��EyG��q����[��k�yj�� �I�z��F8좀���`�͓,j�	���f�c�NM��IN�����˙���wf]4��diĬ��4��� ����4�����{G�l+��8{IA%`����~��u3}HB��4�ܩч�?�o�>�%s8�K���{H���9�K�|�����wZݑ�@�M?]ccs��
���)ٜ1�L6�F���i*��O_���:�b��ӏ��_� hNRF�: �4�a�@}�t=���F ���;�k�`T?�� �q���00���a�K��3{��.q�Î9����O��������<t��p�L��:�̜�-"=W��Q��>��ʤ�T8��-�g+�ri�P�Ѿg��o]$�yw9FoBJƜ�}�-ۄ�y��U��B� ���鸅C�=���*Mf�����`\��s�`�,�8�M�S��G�:�9sOT��9�t�is<�Ȃe;n�=�`�3{�x���N=q�t`8��E���#�8� �ف�qA3&��'�]3GM��x4#���f%w�io�	�����ܽ`�����1]��S���>7��λ�.�-YN~��8�|��?��A#	d9��a�MW;D+ �c@L��&G:���eZ�\Z.i����K3�������������I��W��F޾�����Y���X�`����mX��4H`)f�B.WA��Q�QT;֫�7�7��,���q��Ss&�A�Nq���w�Es���-��wֿ\C�����!�g�R�	��r�.�l�9?�#K�Y�D6�L���� ���g�a�^8�$���$m9Lж-pجm�BFK���aZr��a$9f�0�0����$�3��2�"�Y_�I���_�G��� {9d� �	" [Ad�F� �D��L�Ȏ#/����aD_9�1�m��R|~���׳Uw!,��}q.��l��/N�mJxO� g���K�C������^`��sV�c`ֶ��}q,G��㋳D�#`<�Ǝ�	 3�q|<|t�O��sB��c�������'�&A� �JB@Ih�Q� t��� $�@{Ih�@�>obЁ�z�$Š�͜$t�	�d�X�G*�ڔKAs�a�.�i�6�>��7*q� ����@�B�P��T/��5�@�B������Z5�F%���U�%p�b���X"7y!�H�M^�%p�b���X"7��!%P#0�K 7�����I�s�����Tn�� �{eUf����̮�T�*��H�+�M2<�r�кr����	�I
�)
q7E!n"�    �H��	�I&n�q��&nJB,A�MI��sSRB3�����ICN���UCNGRc���H����Mr:#��j�&#�9��i!�А�i!F�7i!�1P�B�n2B��n�Bq�An��a�&-�M�Iq�n�R����ߑ��a�k�v�7������9�	 � � "�� ��# 4@� ��!�@Jhk�@$��[H��YYHh��	�*�� d!�m�A�BB)��tJhw���;,���))knRB�� �"�t�7))��tJ	�t�I	Y�nRB�䁛�7y�&%�M��
q�Gn�W��!n��MF(F��MR3q�T!"@�	yN�#2��5��TA8��TA8��TA8��TA8��TA8@N'UpD&U�MR�J�dG��DDn�a�dG��9�dG��0H��TA$��qH���&�dG'e��MN�_���P,��l'� ɎB�h�����$�Q���(UIv��J�$;J�2@���� ɎR�1�dG��t@I�PU:�$[�*P�-T�(��*�d�%J��L�P�-t:P�-T�(��J�dG��t@I�PU:�$[�*P�-T�(��J�z�7�$[�*�&��Z�b	�d;)ρs:�L2�$�	e�%�B�d@I�Ժ�$[�!�$[*��pNg�%�V�Q�-To
(ɶB�J����$�
qJ��7�$�
qH���U� ��(t->���k�dW)�����B�Í$ی�*�<�"�ى�lM��L���I���5��눭+���~��(�7��[j��w�گQ�-�_��;
]�	��vB6��(��%8�����I��Y �wj�@����P|� �M���BM(��P�� ��(��$x��������T|�j(��P���K/��^]��S���w_~5֫!�� 1��j�	 �[AĈ�#2�b���@�H��=�{��*�B�w���C �!�GxwH 1»���	 Fxw� 1»���-@�0ڈ{����a�wGܻ���{�MC,
�Zٻx�1�ޭG�E��#�"�w������H�vDL�<@���R �!~�9Y����E��LTQ��Q��"�����8� �.�E1����A��]$�b�w�,�b��w�1mQ;s��M
,j�(�n3���n;�@�n;d�w�B��B��B FA�mFA�mF����ی ��G,��6#�[�wY�n3»5x���k�C��[��nޭGx�ƽ{@R\ZMp�~a 2�#v=�y���Y�n7�@�̇,7x�2
�n?bKe��5���w�ka1��z����b׃���nĖd12aQ�n7bK���v��Y�n7��Y�n7»x����ۍ�n��Fx���|�w;���ü{�w;ܻ���{��GF�~D<��Q�,Cʏ�,Cʏ�,Cʏ�,C�$j�!Yh���,	�j~H��Z����Z�!��U!���Ur
�Z����Z����Z����Z����Z���Z5?B0Q�6B0A�懔�A��9�U�#���ja�H#F�H������!��0QC�����V�2��0BQoz_���7���
(���uL���;P��Vu `�R�E�!7��h�#�fm~��,����r��m��m~�$6)��xwR��#�f	m~��,��-���@��GY'P�����6?BV�@��G�j(��YME�!�I�h�#d5	m~��&��͏8�N�h�#d5	m~�v8��͏��$B����#d5	m~��&��͏��$P��wv(�����6?��LE�qc&��͏�1�@��GܘI�h�#��	m~đu�؍k�(��6b�h�#d5	m~��&��͏��$�y���m~��&��m�yrE�!�I�h�#n$P�����6?�
EE�!�I�h�#d5	m~��&��͏��$P����d1���#��mѻG��h�#ty���=b�{�z�C��>tI��G�� �g�eB[@��}�0��@X�p# @� �� zD� B�X���~�F@�a2)�N��M�ޣÇC�2w��j��{px5��=8���^�px�F8�O�U\�q�� ��Lg0����3B�hwӧ�OF~����fu��˟Ļl��O���s���������l����LZ@�B�P�h=xn�^	��$�5
�&p?�i���*��jC �yhDh�y��1a,2�M��1	��@�� !jq#b�Q�AFHS��6�cL�f-�A&��M�M�|5�`����韧���n����%H\����:�p#L��
m����:!T�Q��F� hQBy��E	%	�%�L$H���5� q���`T�%%�ddT�QI��R�MJ
��D*�p��&�p��&�p��&�p��&�p��&n2B�DX��&n2B�J�MR��MV��s�V"1bFnrR��MV��	��
�07Y!��MV��5p��a�d�xX7���h�&!F�79�=G7i�n"!n��M$�M����� 7�7�&�&�9�7�&!5�MR���H*�1P�X�@b	U�%�
��U�*�� U�%�T!�x�/5Vc��,p���,p�Tve����+�$�]Y�&���7IeW�I*�r�MR��3�*��I
�)�M�)J�7!Ft�MA�pSbD��t���7!F��MA�=p��0�"7	Ek��K�7y!n��M^��@|M^��@|M^��p�� �䅸) 7y!n
�MR���I(ZQ6��2*�tB��l��J�&��tn��JG�&��tn��JG�&)�Qn��rE�&�����$�
�$u:��d��IF�iTn�R|�$���	�IJ�	�p��7�.������r�.��T	�I�����Ɋ��7	�[	t�$�n%Ѕ����@NB�V]8	�[IaN'���pR��Bn���&#È��N
�I�0��Iq��Iq��Iq��Iq��Iq��Iq��I�ĈD�MR�7	iC�_P�r:���/�B�tՅ_P�x�����D�A�$�q��%B�t���HͰT)k
�*�9�MR,�$��$�$��$ù�IE��I�B�I�_p��B�p��
�p��
�p��
�p��
�p��
�,p��
�,�MB*H��MB*HB]��Y3Y�MN��@���Fd1n��&�鄪҄��$���OB쏺�$���OB쏺�$dM�WR5Sԅ'!uxN'�ӡ.<	1"�Ժ7E!nB]x�&��&!E]x�&q�T,��p��t��p�6��P.ӆ���e����	)��CN'��#9��2�p��
��tB�O
�MB�V�f�BJ^
Po���A�n'6V�&)T�$��I��&�{����qPn��A�I�<E�&�L�����Q�Z�T5$B�I����17IUC"p�T5$)�鄬)7IUCr��X����!	�&�jH�H�0p�T5$7IEk7�p!n����)?�&���>Y��g��������W7�����/��}3�<:s��ھi����mS�WW�E�]���NnN�������`o�����W�?�_���������z�Ϋ����/~1����_�7�N^�/˿���������#��|G�Rdb^�88�;8Z�Ce|R��2�V	P�֕0J��4��HȚH�L��� �L��	N�T����#�`Մ�$/hnR&kPa;��"�*l��$T�N趩F�P�*l���	U�B}�4�����iq�P�1�*l�>cU�B}�4�����iTa��	U�B}�4���PW�*l�>cU�B��A5��5a�$�
_�a�r�P�ECwn%���Н[	�?��/)14t�VR�t�VR����T,ݹ�T,�*l�X�s+�����%,r�*p�T,*l%K�
[I���VB�bU�R�+���T� U�BZ*l%�u�7*l)nR�h��$4�Н[	��Р�VBj"푛��Pa+��_T�J�����o�=~N��;w��*�MR�
�$��F��    l�s+��6�s��4t�VR�k nR�i�έ��T�JH���;�R�i�έ��Н[	��4t�VB:<��$K@wn%���I�#�MB6���S��Q�]�),�8���?�*]02���^ӽ-����ғ�;F`�Ta�cD���"�1�Hz�8���.�cwbk���ZtЗqD;�0�˭���ax=����Ƀ�!��c�%�����Kw��!�Xs����e��AC�� ?#��(���F����k��0h=���4���^��t��~�h�8�χ�Q���+3d��<�!vE�ϵ3W���!>H����%��n�����Ic0��[7f���;?�v���8d��
�|H̠���0C�5�5�sm�����E	���Ak�a=����0��`4��c�Z��\ɝ�?�!|e��_:�u�аC�݀��!�����A����5��z̚���1k�� ��}L,j���1q�?7C��u��c���1q��~i�؋��w���ۍ��1d��0������1	�|�;�>d=��n�\9����(zʐ��>�5���S0}��O�̢�<�7B���ֹ�xf�Ҩ�? �o�z�uw9q�o���_����/�w��\���={����>>���ޏ����u����{/��b�<����/��6�>6�(��NY�D6�l�- ;Ad�^�rD���#���m'@��&h�8�
�v ����ì�m�0DF����aV8�J���a_'�s��h2�-Ȯ"�+pc����P}�?^`�\�����I�`&-��� G��	�`,��Q0`�(_a���(� �1�`883��fԤ%d�a0�iu&`�4��@�7	X �b��{�QA�`�vL �6`=�o Ѓ��*0���*�A&`��A�i��A�i��A��U�fP�f����AZ��� �
X��b0�X���( `3�X��b�C���7���I�� mZ���g�w�"��&�<W'��}���/��
���	�(%ϥiU�+�ۀ�����%��[�p�P�ȂS�+Wd%�l �
"[@���ُ2d�*i���"#;I"'@4d�� 2�t!��#�����]R�@X�m)d�,9۾R�7!��Ԙ 0iL�0Q��*
��`������Q0�hFXE٧��0v�U�0��a���f���0`F����0"T�-m&���<��C����Y����o�,��+����!���`4��Z���
�G�X��a&����(�`�`m�L�2�FXB�#FXr�0^���Q0��&�#�ͬh?Q9���7�Uў.0���W4�9";@����� r���Ǥ�# kA��F�hV�:;Ad�1� ��1[Ad�0�uF��&���a$i��a�{U@�1r����ô�����$��`Lg;���anAv����!Ȗ#/;��d%��a�� r �(�9"'@�r�I��I"��
"k���*!�iAd�0A�N�aK�/�F�L���w�F��Fr��r���/sd���)�0�۟�"G��y���.ǚn�gI}����H�W?���� aF@D��# @� �Er�B�s����9x�.�~D7g\��+��5t���Zi�u e@=MB�`�^4rP'�����l3tQ3_A��!i`$+3���X�FrBk
��(0�32��H!Ȁ#9��M#��F�2�k���#d$�55�H^��0��a$��e� #i�1�HZ&�6�HZ�z���9 #i·�HZ��,0����,0��a$�1�К#%r��HQhM�����#E�5F�2�d����:`�(��8`�(�2)�D�H21��2�L�#Y?uXGZS��d��#%!?FJ2�䁑���z`�$c�)��)�D��H��@��d��#YF��HV��=0��a$��$���ˬi Fr2�0k)0���� Y�����gm24��-�2x�&dH�H^f�H^&\��H2�YF�2���-��E`$#4��HV�"0��!��dd�7#�]&#F�x�/�H	�ȐCF*t,��o.�C�B��p�uVq5��P��T-�� �	�z@%!��P�rr+�a�^5�.���Q�"�^Q�*�C�0�$���$5V�&)kBn��a� �^@�aD�����N�r�̞�IK�0�U&��q�7r������
�d�5O�����a���j��J�+p�b	q���5p���L���I��6�*��������9R��$�h�&�n"!n��M$�M����� 7���&�&�DB�d��H�sp	�M����� 7i��7Y)T�鄬�b�Ih�s:!k�Xo��-p���,p���,p���,p���,p���,p����&+�M��q�n�B3쀛�79�&#�M��q�n2B�䀛�79�鄸�!7	E�s���%<p���s:�(�C-\�f�.U!�pN'U!�P��x8���x8���x8���x�&%�8����&�Jm n"!n
�MJ��p�� ܤ��) 7)!n
�MJ��p�⦀q���F�&)T�&��97Ie��I*���MR�dn��$#p�T&���2��$�IF�&�L27I��&�&�hu�R'+�����.\J��p)�¥t0��R:ԅk!n]���Ѕ��*r�L��M2�Pd<'�.<H���2�nt�R���p�:1���ԅ+���.���ԅG��)�.\�\=�.�i��t�^H@Ft�^H��MB��ΊKh�&��7%!]xPR��MI�%4pSbDЅ�$����I(2]�OR�
ܔ��t�>	�M��B���An�_A�*pS��a�(�M��Q��@�7�.�G!n]��B��p���b�u��MB�0��Ys ]���%@�N}��&�.�	i��T�t�NH@�t0t�NH�@�t0t�NH@�t0t�N�z	�p'��wR�H�MB��p'U! ]�R.Ѕ;!�^ ]��:	]��:�]�RiЅ;!�Z ]�RiЅ;!�F ]�RiЅ;!�F ]���Ѕ��%ʠ7IU/A�4�t�NH�@��rt�N�.R��	qS��N��@��"Ѕ;!Y ]���"r�к�.�	u*�wB]��P/� �p'��2�.�	���wB�L��nt�N��p ]��R�.�	��wB���P�� �p'Թ;�.��2�Ї@�>��p��7	����wB��t�NH��MRcnRiD��t2,At�NH�At�NHAt�N�\=�.�	)"��.<�.�	�"���	s:!n"�鄸	t�N�.R]�RUE�.eM�/\�.�_��N��¥v:�.eM�/\j���[N*
�~�R;���L�_��N��¥b�.��a�p����K�t�/\���_�P�2b�p�����6D�.�c�p!UU�~�B*Ȉ��F�b�I(F]��}�_���3b�p!5z�~�B�ψ�¥�\�/\H��_���pnJB�ψ������G�.t�#b�p!UU�~�R���R���Bj�p�N�t�N�AD]�P����p��u�B�4"���Dԅu�����Q.Ի5�.\�[ID]�P�p�.�t�QH��MB늺p���u�Bc#�:�Fԅu����|A��\t�QJ�p��gt�QHgQ.�5*F���?�£�=�.<
)y#�£��3�.<
)y#�K�.�IY�¥<s:!nB]��ЅG!�pL�MB<��p'�W]8�����X�O��ػ�B��!�ƼK��=������ӯ�/2���sQ�:!x�ҽ�<I�-�<I���<	�����9zx���:pm�#�@'�L��NB���{ܠ�!�H�(p�P��@睄"�:�$�_&�y'�"��;	E�	t�I(�N��NB�:�$�{'�y'!�P"�&�=    ��^��ۼ��r��^uݗ=e�~��˿a�n�'�q'��/i�!w�Ԥ��{��S�^�s�m/(���P�%B.�=�� %B����$@�^u��-CuC!� �5�ݞ wCAߧA(���Yd7���.I�P��o;@uC߿���|_��J��Ac������n(���]��`�c��X���.��P����}���ڑ-���~�
��m\�|�V�š�Z�{V���A�|��^2�Q3�1� ��x/c�.PFYr �A��� �UM��R�v���z�r�Tet�A��1�.7�8�U��T����k�F�sV]�2V)�*T[u��P���˽���1@�r�99ʠ�.`�2j�0G��!�m��@G���v$��&�%	t�I�K
�:� m��@G��z���q��5��6	�
I�I(���MB�h����:�$t�6��6	�*N��MB7��ђ�-��A�~k�0C��:�튣2�ϦϦ_��~0�p�����?M��?�9�����+*~_��0W��UAm�JPzn/"�
�PP+t�(��V�hBA�����Z�+�	�2@���.�� U��3��A��e׌�\$5� j�i:����d.lg(�&��s
�I��Q�n��*����d�vY��[���M��#��|��-�ߑ��)�A~�/�3�%���铼{�a�Y�8�ۢ��ђ�U��z-/��\?�+"fx6�k\,�����Dm�o?��%��jQ�ŨIhǹ�q���͖�v��B�5�3�U���D��BC%��ʌj8�̷:3*T�d:KdT�B����5��!N�d��d�4)KJ�|c�*�d����e� 2*��e�;2*��˜�dT�B���L������J��r��>�QA�$��9�b?S!ρ^�I�[��I�+�B�'�ی
%(�o�fT(A�7A��r�RJP2�ϨP�")�D���	{-_��Q��r�.�
�$�9�&���I�pF��I�<� n�b	q�K@�� ���c	�tK�j�e�:�Q���bD�t�|�#�"7	�0�Z2j��
�$󍊌
�$#ɨ�M2ߨȨ�M��Z����s��)`�I���tB�����r.�7ɨ3*r�Pv� �Ϩ��I�9�Ij�!��:_	�KG*�@���5�R'�OR�:��:��^�I�5�2_O˨�M�r�a�Po��H9�I*�A��m��Q��F|aD�uM��Th�Q.�_@i���ʌ
�$�5.�7i!nB���=
�$s:�7��Kʨx�Nf]	��F(W'�����
*'���P*.To"��e�Rq�z�T\贁P*.To"��՛H��
՛� n�7�S��D��$��SH�B
L�z(0�4?D��R��SjW'�o"t�AػYHIs:!nBu��
�P.��$T�� 	��RQ�F��#7I��dȏ�_\x�"��p�B����M?�~��9߮x�ZA�w�no�u��Ck#�e�MqKk#�eH� Kk#�eH$Kk#�eH;'Kn�<����b�4�ʐV���F�ʐFЖP�-�I Kkc�elM\�L�1H�m�����9��e���υ� �Dυ4���Sc -��[��H~cV�}�빐 %"W��Xqu��d�%�F�P�!5݉~�:V�|���UI��ѼՃvC��շZ�n(�6~y�^}�Q�ݫo���P�{��3uC��]���ao��^(W%�eP
qU._P��A6�!Q�Ś��Ř��dc��eԺ@���c�V�Q ��-K�c�"�Qp���}о���|%���W滣�ۻ������G��^!(��7)@	�?!(��7)@	��AHJ��YHJ��B
Peo�� ��7)@	��A���IHJ��B-���AHJ	�IHJ��B
PeoR�({���@����� �U���q�Pq2�Mr!nJx�\(nJ7�̰eoj��p����0T��C�a��M���a����0�eo�=x��q�#j��R��_.�aDM�í�c*!7�Dk�����jh�n�G�P���>�	;�q7	5���$��M�MB��5aN'��M2��Z7�|�$�"7	��I�3��<�n�5r���p.��G��d��O��0�gU���F�}�a����RM쀅6��<�X�g���� ����=�`�u����=��{`���`��n��z���X`��r�8X`����0Xh�L���q��R�U�q��R�%�q��R���`��nW��K���>���q{`9I����`��ަG��\'E-%�䔻��,#"3I�Y�"�Ԡ��h�@@�8h��(��Z��4E���V-@�aa$~�_��������v�}�G>��ɦ�UU�0;n�~̮%)w]۷lX����u��z���u A�gw]��l X�ݟ�u��z�
��H1��Y2�� R��_�փ��n�,�v�}/փ�P���z�J9KAhݾe=XL�X,���uc��`��Xa2���}�e#`!���k�,$|W�{lƄ�E���#K1n���~�[X��z
�,�qMn���~�^X����,�q}	n��X���o�E�b��z�#�*n��ꫂ,���`,�T_K���R}F�K�u=�`C6��~
��?;~���_O����oo�V_#�F��a�Q ����$�%�ɹ��>3���}\m�-�@h�����]צ��v]��,��}��X`����`�����փ�+,�a�s])�lpv�,98d)RH@~���,�q}On������[`��>���X`��+��X���,�q�n����~7���#��WX,��K�fρ��� Rtw�>v=Xxd�~��K�@��X�� rt��У;��'� ݱD?�%�	 Iw,u`)��:�Hݱ��TꎕVP�;VZ@��Xiu ��c��TꎕVP�;VZ@��Xiu �����c)K�Jݱ�z��+�yD�T�@��_�VC-�ʹ8�Pw,�O ��c)~(�K�@��X�� 
u�R����J2A��X-$�v�u��4�D��	��
uV�a@�:��0�B�UcP�Ϊ1�Pg�T��j*�Y-�%��Pϴ��d���	�Pg)o*�Yʛ 
u׭��hX`�n��G�Kukk>X�ZL�,�Tf|	C)�"#K�>T��D��.�X
�.�X
�.�X
�.�X
ꮰ(����@��?��,����k׃Eu'����{��I�$KK�Y�#�M�uG�@��D< Pw4�M�S0�b�{ Aw4h�M�S0�c9���h(TL�X,�sǪ1�:w�� �sǪ1�:w�� �sǪ1�:w��P1�c�TE�"E�T�U�Au�X5�T�B�|{�y���]�r�\�)ZU��l7��\�������8ͱ#���E�j�P9b�js!�cF��u~�*r5�\9���rݹm5T���D��7]�&Z�Qם�VC���Li5T�*�V)��
�p-RZ�*�_Aa�_�VCn���*p�7
p��8��B�Pq��>xA[.��F������Z��,��#����}5T��H�,b���d���t怨<\K6WCn�V%��
�t��*p����j��Mׯ�k���\��WCŜ��M�(��'��P��H�Z��&7��\X�)���h1bNGbDԒ�>�AKH��� %��zGP��'�#��s�t��i�2�p]�*�M���G�����P����WCn"}�1��<�>�A@H������E���#�����������@�(fL7��	����|5T�&҇�c»pjƻpҾ�j�u��7]W9��
�t]�*p�u��j��M�%���7]W8����Ĳa�&ҙ��.��9��ݑVCn���_�麕�j��Mם�VCn�n��*�t$n�xkE�AŜ��J<\7Q[��B�PA#.����˵D|5T���7ؖ���}    ���7 �����R߀8\X�ІK}��I�eu�M,Th�KRA*��IY��.\HY��.��5+��IY��.��5+��IY��.��5+��IY��.��)��I﯊=�Ijt]�'�otឤ�Q�M�D�
�pORߨ���3tឤ�QЅ{��FA�I���H6��pR���.�t����$ŧ
p��OA�IU|
�pO��SЅ{R�
�t$n]�'U�i@n"���H��pORA*��I��t�B��(��I:E]8I��'�`u�$��.���Qԅ�t0��p�FQNz�Uԅ��+��I*H]��>����Wut�$n]�(��@.׍wVCnR7�.\��
�t�ug5T��t}�Va�\7B[m�@N$��*���D�I~� ��FA.$���0\H�a���7
�p�Q�p!�o��B��h¤��9�M�M�ԑ�	��B*�S���OA.�2>a������B*�S���O3&u$n�7����"*�M,T�M���0<��(�#K~��Ȓ߀0<��(�#����0<�8)�#Iʫ ��+=�GR���0<��� ��K�Gօ�#�r��u���Ⱥ4axd]�0<�.�AY2���D�s@I"���H$&�G��(�0<����#IB�@Ir���H�&�G�2�0<�$��!7�P��8<�@I%	��h��
�Dj}�@I�	���Z4y��X��D*�J ��R���Hz	M��4W�G��`ax$��%�G�+Rax$��%�G��`�&�Khax$��&�R֜��t��0�]��%II�������H��2�t��H���H�EM���Z���H�EM���Z���H��&P�G��(E�&���2<�4�	�ᑤGO��$�}ex$�$P�GRMEex$Տ$P�GR�Lex$����D�WP�G��+�2<���	��$�I��$�Oex$	��#I̕@Iµ��H�%�G� 1)^8�暐�H9v'=�&��z�ax��F@%�0�+�)��T���H��#�Wa�	;��V;���E��	;���m&��L;���)#7��
��4k�����B�D��PN꒒PN��PN귙�c8�[U�>�	��J���c8m_��XsŸ����M$axfI�PΊ%@X�X��H6��p�W��I��@X�+�K��pR����@*m� �r���@*�� $Abax �{e�7e���Bn"��f�'�mHax �{e�R�Wax �{e���ɚ3
�I_�� ����1�c�7���|%'q�I,�AH�#�c�D�&�;�I��p�t2
�I_��('�qd���5W�&־B�D*F�('��0�s�9/�S==��gT�ZU9�']�5�P�E=YU`��� ��P#��#�*̵�P�ՓP3�5�P��X�ܤ��F�&ҾF�&%�pnRҙ����M�II<��2ˆ-7=�
ܤ�S=7))��7�N:u��$U�M�_Z!�
���n�$kR�&�\V�eM�M���PI��@e�D� ��	��t�&�B��qS&yN
0W��$nJ�M��	r�B��qS&Ek	��b	��2�%2�t��f�o"qS�����q�&aY�t+p���	�IH']n�I����t��&!�t�IH']��ɓ�� 7�N��X+��I�Z��<�_p�g�+p�g�+p�'YS����N�
9�.�79KT�&ǚ+p�g�7*p��<�)��
�Y6�9�zq7E7qS�D��7EΩ^pS���7EΩ^�t�)�)r��8��8�TpS`�0pS q�n
$n��M��M�)���77y��H��1n�d�c��BŸ��
�t,n��NG�֊@NǊ�r:V�&pΊ���Xњ�;+Zx�cEkKhX1� 7��5Ѕ{��.ܳ�5Ѕ{V��pϊ�@�Y���=+Z]�gEk���ht���P@�I��0n"�tឤ�/��D%��]8i_A����#r���t7>���˟��ώ_�����ӯ����[G\E�a)�����:qR�P��'UDЉ{R�Y��'��ԉ�^
��I�Iu���:qO�*������:qR�NQ�&%�+��I�$u�:��:qR}]A�8�֡�N��,�����:qV�:q����N��;-���*�:qO�vЉ{����Nܓ�]t➤�*��$mWA�8�8#7�b	Љ{�ڵ�N�;7�N�;7�N�;7�N�;7�N�;7�N�;7�Nܑ<�`�/��@'�+��@'�I
�:qO�M*���ʙR�ݎ5W�&R�L��'U�ԉ�*g
��I�3�b}�A'�I5���]8�+�t,T�&R�h��ӱ��)��	t����Nܓ��UЉ{Rw�
:qw�!��UЍ�k5mF�7��(�F���+���
:sO����3���
:�@z5��3�~Pt�ԇ���<���TЙR�
:�@����3�X���<���
:�@�Q=r��ԙ���<�^+*��鵢��<�^+*��鵢��<�^+� 7�n�*��鵢��<��o+��鵢��<�^�+��+�y i�*��I�WAgH�
:�@��UЙ�Ư��<��%t恤�3$�u7��5"7��u椗�
:�@�/SAgHh+����n]y �n��+���t��㷂�<�z�ֈ�D�%�H���H� TЕ��=��-����k#mW�<t�����6����t���u�6��ЍFQaq�Q���]�f�F�q)�Iȍ~��c��V; ��Y=m���Y>m���Y?m��׷ �Q W^�
�F\y}K������mF!���:�����ZCp�u-m����dh���RΜ��g�ƍ���;���]��������m�����u ��6
�5�y�K-����?�!L?�f]�tl>4��o���w�l�wa��N�w�����i�:���ڿ���^�������e�Q@�z�k�6
���>
�Q '_w�`���ugF�(���;5�F�|ݹ�6
��7�d��pםi�@-�%	�#�u�
�܁+�+�h��^�,-*���hQ'(���>��o�0�M�o����M��	�+6�Z&h���$j��!���b@����򜚣	
���1AA�x]]�Zq��p�ն�Q 7^W��F�x]�Kh{8�A'Tx��h�P!�t��P��(��	��ӣyB�����7ͦ!��(��	�oot�
�a���RTs��G�*�	�3������P�!��2*|ӄ��U�©qP'���<�9���U�©�U��Q���z�(z�A=�p�ꠞC8�^uP�!E�:����W]����M��CF�7����TZ���� ������\�wpz�����7��a}�b갾��1uX�����:���|CL�wp�!��;�Vw�P�8_�R���}�isG�"EwP�8�����*���:ŻyOC�F�t`R�����P�8M�a��u-�j��U�Nz��"p:�K�M$^�z��՛J»��F�w���@=E���m�m[�7C=E��]�)�V��S�mAꠞ"l��g��Q$���uX?��[<�Sl�
��_
)��z�p]O�*�O���&T�>ΗO'T�QI�u��4Rd���M�	��Y��6�s�O�DL���)*�A�	��ǿ9�d���?��Ei���4Ӵ��D-�Y���WB�VB@�ٕנ��t&�%�aagu�3FY#F]�X���@�v?{�_��g?n�,Vf?Ϥ�o�I �V�#F?ތ�Qd�]�t��������O^��4��Y>���u�,`��:g�x��sf���I��ϓ~
Zrω�
�d�E��ݟ��p7W��;�m��Uu���g���	0�)6���ǿ����c���_�w��ڽ�Ѝ{���ni챉�K���R�}�2�
��*��}���n���E���$����Y���/���:�Y�i^m���rJ}N�����������F��?_-�|i?�$_��[�Y|    L��6| ���� ��
�ʆO ����3Y�N;�z�_��<�v
��g�N��l�)�z�M;Xϳi� �y6�`=Ϧ�����F�v�W����O�Vx����U��
�*lz����6�
��6V�]�>�gvu2o=�U�G[vv\Q�]#�5���5��>8`�Hk�֋�&8`=��X/�i'8�)#9�	X/�������|���d�XOɬ��Y���!9�	XOش��ؤ��苏����>�~~������U�9E������,����BX+ü�]��bU�תk(�����*��._������ٽ����}jGs�Ol��ʆW��l����^���=�| ß�F�ʆ��� ΄������l��z�M�Xϳi' �	���Y�O:<��g��X�s�4�1ڦ��<�!:�ɉ���[��&���J����=F�g�-Q�����%�&6����-V�g;��e��)�;�Px��+�^f9
��ٴ��z�M;
���A��e6�(����2�����|���uɦ�~I�W��Q�w��+ VY�ʯ���dګ`-��*X@8��6v�s��vO6G�n'ͽO����h���Y�s�ĂY(�03S,��=su� �L���y*`F
fL�`f�tL���R
fA
L�H��<)v[��"gm��"�
�P�p_��/�C�r~�!��&x(R0+��CxH)<T1��PR
U�!��PE����-�P��Pr_r_�x�1�3:�!��耇�̎x�1��耇�W�r�x�1��耇<#_��!&���y�!O�!<�)<䁇<��<���N��C��"Q�<$��!�
�P�S���⟂<D�9�P��	���+�,f��mL�����mLJl`R�6x��%�b�(�`R�� <�(������C��Cx(Qx( q�x��;D�B�����pB���x���D�!ʻC��C�3;qrވ<�Y[�!�FD�p�B<Ĺ�R�!N���C�;F���E�p���!ω�5�����N����D+`R8>a<D����b�I ��� �I����	y�·	x���$�J�!�S{�=X��!�<3�C��q|%C<�����2�C�ϐ�qβ�<D9�3�e��$#q�x�k�!�YV��
��@O-������
��͵ Q8���E���ݾ����#�!J�C��C�z�X��(��B<D�w��!J�C��C�z�X��(��Q4ܱQ�b��z�
<D�wP<D�sU<�k���V�*�3���a^�Y[���Ou�C�c��C�� u�C�c��C�8A=�Rl�)ņ<�C�8��C<��><D�+�x��?A=�x�R��xH8�	<D�� Qt�*��p�EO-�u���:F�<��2%��(q<�3%6A=u��	����C=5'�G=����9}�4 q0��(���Ԕ�C�zjJ�!E=5�_������HQOM�}׋�z����F�!�~^��'N�`B^F�	W�SSj��ԔE=5������R������F�����#�@�\)ZU�s���Tរ�}
��=�*��Sto
zjN�����S������*�9���zj��EQO���PO͉5AO���)�)�+�zjJ}����RK����ԗ)�)���zjJ}�&�!ʙ��=��L3�em�?��ԗ)�������8�'������Ԝ��SS���zjJͩbj�[��漡cj�z��!J�sE=5E7�؟������=����qQ�OM��؟���E�?5���bjJ��ԉr�`jJo
��Ԕ�6���}����])����E*����])����])�����	�SSz�$<D��&�SS�<�JO��ۄ��)z����)�����)�����):����)��	�SS4����%GJП�Sjf���!Jܗ�?��ķ	�S{J?���e	�S{J|��?���a$�O�9q����:�$�C��!�BjO��IП�Sꑒ Qj� Q Q4�I��ox��;�%�Ox�R���e�f
Q8> q�����'�C�s% qr��<��O�!
�bjνI�x��+:E�!��6E�!J]G��C�����(u)Q�:R��Q4�	�Ԕ��zjO�9M����:���C����-'�x��؟��{-���S�U��?5�Z��ԔoJ$�SSzu%�SS�I%�SS�<	�SSz�%�SS��%�SSz�%�SSz�%�SSz&�SSz#&�SSz�%�SS���)}��)=S�S����Z�뮦a<�	sZ��y�{�l�%����� �Y����Zy
l��&lX�%W��$ئ�6���VX��,K.ȑE%,��,�oKX9d)ς��4��,�"�o�X�"W`��"Ǌ��(�����Ky9��eEX��Y���b)O:���Xʓ�6;`)O��� ��$��2>O:����OH�cv�R,N�2>Ke,����R9f,�,���R�t�e��)`m]v�YG���4X`)%���#K���#K���g�h{{f���_��0l������;��w���:���ڿ4��Ȣ%Z
,Z�%���x�u�^D�U�"�娂Q4K���B����V
���'��e���%�r��,E��*,�
�R��R���b� ���X*`��b��,Ŋ�B�1[~�.^�E����Zoq:<�88/��kq��{�ŉ`/;�kqp^����$X��r��a>/��kq ��8�_��|�ں)�A~��~-�A^�� ��
��*]!�`�!gE�x9t��[tD����؂�*\VH��K�C���UM[�vv%����kq�K:t"����b5�O[t(/_�c��+�1���'5:.�^����z��F�u�+q2�C���kq0�X-�H��چv���Xw+�\N��r9��V@��hw+�\N��P.'ڣ#(�EX&�夬`P.�D�E�b�Ԡ\N4!(�M��D�|�f�(�M��e���7$�`��h�ڠ\N���`��:�=�Kuܟ���,��1X*�N P.���A��R���,E:�
(�[�,	c)KP.�Db��0�#�Tq��X��rYX2�����3ֲ�����eeI�
(��淠\V�߂rYi~�e��-(����P.+��岲���ee%#�K�jg
��U"[@Ȭ���Bfeռ2+�歀�YY�E��h��R����ʒ�2+K�W@Ȭ,io��X&BfeI{��%�- dVZ�	Bfe=�2+�ػd)�yBfe�����@Ȭ�[���h�m�b��,�r�,���T�e��j�VbX�EX]��,r�`Y�c�b��*3>�)���YQ{K�E�b �VV[��le5!,
���cQ��X}-���ų(��W�R��h&�=g�6��(H�������#��6A,EXAi�|�X�u%��h75��lYAMB�b|�,ˁ2�R�M�Y�"Jƌ���3>K��\Y�
h�#��f�l�Nh��6 ��d�-���f���k��8������L���y,r�y���5;�Kuit,X�\��koA{�i75�=ϴ{)Оa�p�=�4�	h�3Mw��L���y�E��=ϴ�[Оg�MM�yf]�U��io+h�3K�U�k6�X�:T"��Y���W�z)�l��h��R�'�
����V��c)�%��<��+h��^���<���cC��K��f��+h��Ҿ��<��:+h��A���<�.�+h�KeRQ{���TԞ�DU �b�[*j�Y�
�� �EF�"����6`��"ǀ,E����=O4�K���紃���BO'��<�B8О''���%���=O,YtE�9Y����R��/"K�`1�b��1�}�K�)D.�=�o�_H��Ϗ?�?�tB���O绉f�����dncx���7?8�z���k�ٻ	�4�պ��)Py�O�N	�:�.S�����5�b    ���w�y�m';��_;'h;�Q��Z�J����8Е��W�kq���Zm[k�6�i�kq�m���8І����8І��1�U8S�mh;t��>��~-��Zݽ'���׷���gW/΋��#�}���}c���I�ď;������7?�~�W�����A�=&���_<}��������p�/s{F��N�9��%TS��nFɰ�����BF���*Ll%ACr��p
�C���+��̦�f���XK֋�&,�I�M�2Cp�0C�/�����g��Dbǿ9�����L����_����?�������v��R�<b���k�b��nJ����*���Xqk}0e���c��L$��Mg��f�Q�Y-h�v�Z(泞��j� 泚��Y)��p�V۟ 8k}�b�>X�<��Z��p���D҄�|�Zt��C\�ZV�7�gG��W��g8;J�_�YF��8x��޺����o�����kq��:�����<v<��Ο�>�:�@<ڡd}-N��(�R4B�P�p5ޡ}�jN��MV���:f+L�n�Opg�oO���e4w�\	� Њ3��te5���� ���< ����t=� @�Y]k�a�d= �^�!���W4`���3���(3���.3���!3�ݒWf�+�0�_q��� ̐�#�̐W�#`���!3�3`��4�,���ןr�4�n;Žu����v�^��3� ��{fvc<���EJ�� �OR^{g���&;���3w7�˾�I~��}����^k��#*y-P��y%PŨĽ �T��Z���@��Ŀt
��&�ͿB�����>�%�"��# �/�GX�|G�mb3�ӛP|�uI�Ha��7��n�Vf����l�E�X^f�X�`=V�"�%��"��'��k��N�k|!��o;�?����*mzz��%���&��yL����1�����X��ӧH��,ˤ�X�Iy�%�I� �,�N:�%{�ْ�	�1x�Yr��*X���X��XJ��
koX��XJ��*��X��XJ��Hi�`��b)A�bх KU��"K����4@:���i@p���y-����eBx-��|^����`��N��Ӵ��(��zv��|���Zȼ�-B�{�-^;�j�Y��������Ed�լ$
ଶ]1�Y����¯�آ#�x-��[o�2༜���Y)O� �"C��bVʣx_�JyԦ<�Y)�B "W���>��Ʉ�a�jį�XB\�5���r�����kZ�X����Y���0KY-{Hw���qGW�⎎���� =�ղ�t~=�-WV؛���%	sV��
̖[�E��,�4{�eYr�e�f� ��{���ed)V ����n��,r��R�b�lY��6
�Td-r��,�(�R�EX*�f,E��+�R�u�d)�1_��:�A��R�E�X*����,�:�*���8�K)��*���X�b,E�[d)]T�R³d��x��,%4N�`I�(�,�����`I��� �$N�t��S�,�mo3��b)qKeK��X*�X�C,�Y,呥HA�x`)��x�R���K���C,�i{,Ŋ�K�*M�c,�"G���^o�Y�,�R�K{d)]�R�K{��X��"K�.�E��X��"�R��j~N4i�,�*Ւ���y�4X���=K��aYG�Y����@�KK4Ա��($@+-<G5u`�c �ꐕ�qu`�m�
,��K�
J%�Xʱ
�$"K�b��,Ų�����:b�=�(���b��X��G`)Zx�K��V!����
���(���^��X'�K���D1�b��Kў�X�����R��"�{)GK4�X��&��X�ђ����IAR�Ef�h�����\Xmf$e�-�oፏ�PM@{�X:G��R,���R��������sVk@��R��:�s�j(Y�E�=�Q �s�9ޞ���B{$���8�`,��[О�( ��cuԞ;�lp2�.P{��*Z�� �A�W�y��w�/W(�}�b�_���)x�/Cc����7�2���հe�F� 4�x�Q�M����W��g�ь`n=�ٌ���������^�n�a�����O�%DϿ��_��w_}]%s8�r/HyE� HeE�h�N9�JHj���/ �����p�؞�b��~;�o���.����+Ti�
��t��^�ҊH�~�μ�<��H�'�\		x��Ec%$��S7����tM$`��\v%$�����G�=W�#Ҋ�+�ɭ��V�����o+��G0:X���qsj�����Y����k�.x~Xq�x����<_לx����<_W�� <�+�x �h�x �xf`��b\�#�A@�X�""pD��~X!��X!��tYaE���
q�]��+��x@Vd�<����]�q"�@�O�o+�+ڀbt�"o*�@g����Ê�b<0�g�oϟ=^d��y��F�<�v��4Y�����n�`�l&�&����e�I 6�`��(E�,���lb�"K��6K��K��K	k�X���6�YJ爄�@X���Ȁ�ʬ�6Ke��f`�L�d`����,�Y�m��4��ʬ� Ke]��2�-�R��K�l��
ˁ�3K�J�ۂ��((�R�u�`)��c)��W���uU`)aXJXGA�9V`)a�c���59���f���-�R�E�0[]D� �"YrtfKb��`I,] XKE���jMJI]K&�Tt`I,]XRZ]XKyd)Rx=�K�X���X�C,UY~둥X��ϱT�g��ȏ������ �o��'��`d�H�`��U0&f��ާK�4%/�	��s	�/�w��>�{��_%uw��7]����jBkz_����_�1a}yӄނ�'�s�9�� D\" DZ"6�?8�E;A'�"\ ��qz�8�b~� Bր� �׀(� ���7�5����ɟ}��?mS����O�����{���^����ӧy:��{/����~:�������?�8������q�O4�YL�7�L{%p��S.)7�3w�v�����ڀ�����vW�]�6��q�ۖ���_�T҂���H��4�g�"���" e��8I�,H�F�-��&�)}r�(���}!��5���3T��^������/���{S}�;���_&���'ǿ:���?���������=��O�?~k(�e
@��>>�C-푇9��[�m(��N���D��x`����=3��e�J=�ʜL�'[q5�C;�i�.C�d[�M��Y.^��
����Μ�����Tgw��B3�X�G���v�h��h�2���O�h`m&*��f��h2�&/�9�G�N�h�65l1� ���ht�Ѵ�oM�e4|�RQ;��48�&m�S*�S.��l�6�Snᛖ3�G��f�Jf�;�\�vYA�:���l`7��y4a�甪�h�2�-�X�F��<l�6F��h�X�lG��re���~��6[�S	��-�q�-FV<��h6ةV�+v�~�F�f4[�M��,���k��h6X���	^F�g�p��q�T�&��"������7[��<ܛ�F�X�po<�q�������X��1'��k�3|s�`m
��od��)�3x�l��bYv�=P�G\,ΜS[�p��(�q��.s2�-��X�ɐ�p���7o�S��b2�-���ٝ�|�;U��%�\s������lpӖf�bn�;�\����f�n�bo��{���i���j������/aN�]�nB|�]{"oB�� ���m,�݋�4���	[��n�`�y0�o�;Wt���6�@L1�i�rLj-j؃�v0�6���2SlcW&]��G�`j���e����I������ye�]c����`O�{0�[���0�L;��)��흎������/�3�M�44�@��?^���L�v�lA�6��b���Y&�V�S�L�X�.o����(gy�_��?�ȡr@#�
T�
���gr������ J    �ަ0�BY��J1��IJ9���1��Rh�}��m�o߹�����Rb���J9�ۇ0,(���71,(�����6���<m_ʰ�F�	�����Y^����2b�w�b�f0$�)#vO����`.�a� {�9G[��2�=����!��r�7:�S#E���C�@91R��+G2$P#E<e8~3�r?"#���1Ҋ �oB����Y�=��V<qձU���^{v����4�)�h�Ѣ��LC�v��ev������|�h:�e�����{��j�#��*�A�����<��>=�m���3 �}m.f�39r!"@�D�j��Nw$d�,r&��{@&�֯�Y���,��F7��b�i2��
��m0w8�\�@��l0#��@`i� n�DL�6��b]Ǐu�>�؅jG��7�86�� ��68�yB��`���,1z�vF����`o�F�A|Ռ �b����΅�a[�AF���7�N��@!R��@!R�[�pb� NT�ļ�(���'n�*pb� >P�ĸ� '�81!'n�	�D��tN'����tNL�u�[����A������1g��\��i_��)C|�682�i�s!cδ#e�ļA��������#(ȉ�AN��BN��rN��r��iV.ȉ�8�l�'n����b��X7X�
�X6��
�X6�Ċq��X���T�n}���'�-v9q�5 N,�H8�l��8��9�5.����!'�6q���Pf��r���P��-,8q�8��t��7��N�@�!8qm�x��Ta��1l1�D~�*����!N�@%*8q�*����'z���@��{�k ���JTP-,x#�����ja��@�(��@�(x#�e�E�2no��lhu����pb� o'n��İ#̝78�pb؀pb؀pb؀Ɖ[�p�l�'naX���Ʉ�Ա�/lq2a������[�LP��[�LX��E���[�LX��'b��'�/lq����[D�
��E���[��`��o,W�p"�/l�c��w(X��A-�`��wiX���}"�/lP�%X��A�%I��[��%��-n����-��8��?�G����81dw�?�����n�����̂� H�-[`k�[�ef�,� �� �Y�
��~h{��6[�aх]̗)�t1�'X���ڄ+ ���,%,J�R�u%`)a�mB�b�mB���-�T��-�Td�m�,�#ko�e)O;
2�+���R�6[��X����<͒��<���R�fR�R�ue`)�:�
�R�ԫ@,�i��R�u�d),��g�T�X��RXJX,U����R3>Kd)NV0�w�������
ٹd|:��a�(���`k2���VR`��=5�j�p`�8~���/�ԙ���.ʮj*�8QGke���t/z/��x�彘�����/�L���ߩ�oV��w�������}�x��g����P�����ŽW��U����w�R�]��½���fnCh��iZ��_�������')����=���/�k��������k��?M�W��n:�,s���Si��G ���O~��1�e�Y�e�ɓf�jt�YJ��ßf������Y��YN�i��:P`��nf)범��2-e� i���$��L�k&���RD���A�����\w������"N�S��ӟ���������z�Z�w���w��o�q���O���l
�O��0���ޒ��)x��[��2��r�`�v��,�����aZ�<���~��ۋ�4���|�}z��7�@�?��k��SI.H:��H��m[[�!M39߳�����rvZ���ӡ�kH����O?[`�~:�޷�����޷�W�Np"�p���3����M<�~���^�&��=��e:��#?���8�:�s>M�x��������2�ƴ�\É����eRe7~R��fRu줢����I���IM��gq'���`���~���YL;�nj��Tfs�3��u�4��_���i���|n}C��r�v���Ҏ�9Iuoa��P	ϳz6q�p��������;����7�ɛ�����������u���7����c������aw��˥�ǲ���4�D�@���<���|*�#��a���
��~�g����y/���&ޔ��]�i���������i7��x^`v�ab�����3�C�`|I����7�u)=oN�R�}k]�����&�p��ys�I���x���/��,��@ �Z(͋���5��,Ԕ7^����� �/P��4� �a����*@��=vCIK�^"���&6�Vq%��b;3��3n6��5�U�CP�A�!�k��W���GN����1_|�O�Gi'sл� !<N��>������-�N�����ln�|����}����%'��(����Ŗ�,�q��3S0��ws��g�a�ڝ6�ݡ��{j�<M74���a�/�}���v�0������'-y	6y�h���iR�t�&��%�y�]؟��bԓ��d+R>�������&�S$�!��K$\ex$����C:&�V�o�ʂt(���ꂤ7ѵ	��)��;��ͤR?T��mqA�����b��~4�mŘ_�	�m��_9|�[٥@�VM�[�`�`��]�-�?�.��)�S/H����S=�#@2L�8z�" �P���$�������OI}H��"�3�a� 4F�On��P �piI�s4��2���S>B<�����oֺv*B<a<���}��@�O�jR�~��#��83���3y

��7A}b��B�V=�I}��)$�Y�sR'P���m�UH18��)�.�T>��ޚ�Us$�����*��*�#�N( �h����z*pE4ǯ���=�@���~0�*0E4Af�������~2:JWp_5���"�ө�5�T$�_Ɇ�F�o�w_��qq>�ݓ���P[]��g�r�֮�~f���k�&�zA۵>��h�އ�`Ѧ���j���-Z2h�+�)�邖v+�%ط��E����ӥm.�|�zxzj�t����������:�My2��?�y�;��/�!Ϗ��n�'?:����O����wo��7?��4�t��"�ICԳ�����^G�x���F��ƛE{���� ��f6Ca��I�2���գP5�/�ԫA�[0��F.hG6>�^=�������Wo~p��񟏿;��
���.�,/�.O>/M����es�\�.V��y	.6Q�桵����b�CM�,�q#��$��b�N/�7XZ�l�����c��n��6��=����������'���<��k�La���|cעׄTA������<zsf��5�9�>�z��w�Ϗ�K��z���,��n4Ԝ��|���gbtyhA��G���;y�K�?}����z�:�㛿�d:����W�b��E.}N)������`}��a���'�ݾw /o�Z�((�Xz��a�@%���U��Ye0`g��FC�UY�w[�����vo`�T[ݗ�JKs��)�Y��E��p, ���>�B�\��Ma�r���G� ���+��w�H��X@Ej�H�c�����pO��v�3�q|�Dٵڇw�55�W��?s�>{���%����<����#��s*r���p�o�������ل{�V]g$"�>�j�z?�=�	�k�=��8������\���-�+7��[�ܺ&�8��n=\�q��������*ׇ�Q!J*&J
�k��@�T77��z>$=s�Wrs'.pU1tU\���	��^�]�p^ n�Ʈҫֹۮ �*&^{zGv�V8lL�j� ��Ər^sdr՞���o�:�S���n����t�&O2�$�5{_-�iN3z� �Rh_$�D�]H��2�?I)-H{7)�.HOe0R�� ��H�"�O�0��* Y�ۏ��    �0]VO�9���s���[�2xN��.�����#��܇�H�ɬ�S��uE�9",Hs�H� �P�OO�ۇ���`$��d�|�O�I����S�G�h��y�	8"-�\?�!G$1H�gnp�.��#�P�{���	8B�����{����=^=�����!G��'��}H�j��qpĒ�#����e	8B�Y��H���t���?�����#�9s�`J�ޜ�ep���#��5��L-Gx�k#Gx��ч�lN88Z������ӽ	8B�?��h���3p�3�a��e�W���52p�3�G#G���m��a3p�3��a�-GT�k�^ۓ��	9��~.�p��8��Gt�S��6��a���#��s�m�	�#���x� Gð��wa8"��?��C�ð��'a�8�2lNطOG�a��Ѷ�aV�� 
r���G�8BG<��*�6
|;Z�#�p���[�
!�#�`.���`0�W��O��Q�>��9���8�,V���U��b�������ގ���5�(��@͎8��bͧ�	�8��bL���=�)(�jo�:�wb:�J�)s۴+ `�bX0���=�(�nrc_9�)D�A����xH֍;�N����by����j^�|�<黧TiY�TƲ�x|�X�?�]<�P��=u�~�S~�� ��S~������O<�C1���!p�� ��ޘ��x��y���ވ��"�;��}HH˜J{"�ll|nP4� �!�1������Vcc�u~�&&z��zwI����0�:Vf�׹�������
+�;~
+s�e��v�ܼ�l��?6���y�Zbܿ���Iaw��D�q:'�j��w4�Ioa	L�/Ӛ�{�@�j���Bͧŷ��t��(~'�'���"�V� }�ы@ir����[C�>�����n��Pm�ڑ3* PTH�V�=�$t� -{T[c��=AgJ�h���ǯ���)�����ǿ���`���X�Uˇ�¥w��a��Х���g����K���%��!<>�D)�R���@�jQ&YP�8�Y@��,+��\�Y<����ߏ��|T<��O>-�u_�sq�>��w�%���vr.���ݔŸT���[/��'6L_M�ޢֻ�a
��c؇)�	�~W��8�^>:u|�k��.�� W\^.Y��m/p�١}W�,��[�i_r��k>�uh�a�џ+�s�&k�9oߍ�6@�v�<GI�_�F!��v�]�Y���~�Z���;��� ��2�y�>�������UZ��	��$�2�z�L��:����b�_Ao�w=�K����ל:p��rFN��|̊�&>�3P#�������n�X�s!�O��;p =9%�ﬗ��)�����,��y��5|�`�=^-�E���=	e�	f��7)K����-�d��]�/B�	9u#���3�ʀ� _��1�g�Y�͵�g:����'MMO9������F���ߚ��oM�����i���7��kiaZ�o,����0�*���0�s)�
���H� 0i�i_�&�C/���j�^x5��iޟ���r-^������WF��C�X�b]��ce���e���*`�K��k�-�e�u>�Y>��ה�1<��)��#0'�~-�� ��~�b%����V?�`��k~�f^:~��C2�%ñ
`��cg�ll~�m��d���"K7��07	�k���� ٘����u�����|·J)q �,s�l�򹘼s�P��tK��l�7t��{�ܓ�l��ͷt�#2h���΁և�v���ந�5���/㘛z�ơf��eU��H0����s�%�8�G����8;��]�
�X�t�i�΁��}i�Y�qx���w�S��{�[�!����p�.ҩ�q0�#��x�������������0��|�|pg>Ԙ9�z;�zl��4����a�]����s�'�޷ϲ��W��:���zJ�(�-(���%��BJ��Ď�L��y�	'I�eŢ�7n�N*�����n�$Cu���e߇"�bjV�k_�Z%��<�bl�eU�V,J^P��}�Š��xe��0�2�lb�a(���x���x�.+��^�:��k�'�e.�_d�(b,9u�X[
�~4(�cź�������Fߏ�_��}�W�/u$
��)�~�%�韛.j�Wv���/����a�Q����!u�K/J �_FO(&��k2(�X7
�˲/?0��/�DJ�/��iB��R*K��)RzA�c�!����+�����_����HKYڂO(�2��,M�'��+�_������@�pV�dPf�J����Ǯ�D�w�̥��:Q��]5s�:�:Q��ˉ���N�}o|���+����/&��`������?��X�\|_Lԧ}�5��&w}��7�}o�W���}s��&wc~��f_\_lه�羱d���}(��b�q?r_���D�~�����h�'��F���7$	}�D}y`Ɨ0G6��'w�����4��2���Y��wVv�XB�7��S߹��'����m������~5��0�N)��ׅ�s�}r7
�~]8���K���܏�(��~S+/(��w�h|���e���� ���o�Y�P"��Eu 
z�3sy���%Nns��|?g@���2҉�^i����S�8;1sIW���x�/:�_
��7�����% ���с�\�_��K��E����}��}8Œ�dxS
�%����K�\�&N��7$S��"LS������EE�߮�-۬��q+X!
L�|df^�������o.�g��i*�ɼa�<3:Ț����QHt2N���(٠tE��(�5�%�}苛;Q kJ&��]9s'
�K6���8�(`��'m'��ƞ�,�
'K�}�e}(�/�0L�v�N�b_���P<z��w�=xe1wu\�Q�S̍I�����整�.����;��s�{�bnv���#j}���F�\�����܍\1��b#�|?��^J"j}�9�¸��Z�lN�=Y7
�~6�E�ί|��K�n����'���ژ�ut�kխo����U��>g�V�F
)F��E�w-^n��On�C+Vn_��P׽"z�2 �T�`�HqAj�C��E�oA2�6�k�������ݟ��O~�������'s�������)�����)����_��i-2�S#{�k�@��i'_���_z�-ú��S��b�km�.0:w;�j���8�l�@]D\��O�c���5���B��*��� �.P���;J�,��ڍ�J U�p� ���* �Ưo���]Fy[�`�G�1w��2�#pG\�>޶�P�����YwDof5��3w��3Mi������k.�H(���p�\>3vV�Зxtګ�f]�����@�&_��@�vP�JS
]�	���G��漖�������c���A)���
�{�Ye2
B�b|������R���59�h�$ŭ�|������$g5�����a%`�����lH0:�H��&I�9#g$K���8#���C�������D�P���l���ǻ0��f3����-�Q�C[d�W2��ʳ���,Z�����y?�o�R�����un>p���ֈ�����F6MP��������U}h�Ǘ�O����T ��a8X�d����ݿ������s�ݷ��V�u�
�2�Y�ᳬ`��̲�V���,p�n��~����x�q0~ם��}�z{�o�ׂ���,˺���}*����7-����`P� �dɷ' .ح�Z�^\�q�=.`\ѐ�M3���9�Ba7څZ'�LĂ�p0`��CL�z�/`q8X 0�`:b�;�h0�}��>�h0�}��
���e���C�
�S?+2��`��`�zς���W��`�ё�:�e�AF��A0�h�W�ٓ���>b�!��T-��`� ����� ���s<Һ��)�ϥ�ǲӇ}O���    �L]5�ӿ� w_;�����?��s��}�<����ɟ���� y@Ji���z o�S�{��q�g4$��)�s��q�h��W�H2��~8�������zS�t����C���ot�޴PB���
&:�7A����NT�A����NT"y�y=)��/
�����$�����^ŝ���X�����)��m��v�U�p؛(����%��?:}n�=Н���ק����t�`�{;�z����OM}��Y���>��M��4�
C��s�MCx�[ɻPO2�?:}n���Gvw�5��E��ZOB����园��qW���.���?� ��mjZl�`"F�`��e�`��� N,�����~�yׇBoAN�|��]�8c�2dL0~���p�Bܓj���=��$��ٴ��b]c�@�e��0+�[�j�m"�j��9 2�,c�JDVpEGDN����<��=�`�FW��a�r#1y���4��?�����t��*�IX6h�G�"9.Np�ơ��I=��D�Q�5)˚��c���H���&�<���S�<�dB��#yzC���
|:������pSk�uf��|Zw��˔�BK6�y�[sBVMƀ<0�?�����(U�t�0J%R�I��Ź��d����}n����w�>~ڲ��]O��R^�J���T,R�F;#���H���������>�l��ru������@�/�tO��gߓ����]�8��s0�bLį;� �u�u��h�����������`$��h�m�a�^�m@)�l�n?x�@)S�� =6��`�k?� �Sl"|F�����<�}����6�������oN_3N�^����2�v���\Կ��e�C회X�K��	jV��
 %(��:��� T(�@����R�rJFC%0�j�nX���� U�Y��P0�Y7�
�JƯn0�.��0Pa1mM*�B![D3��.\�-�a�����t�n�FC![,t���B�Hj�_U`��o0�.b��Rͬnp�>(��-��O]P�ެ}X�̪��j_.1PƯ�c����*�.�J J�`�MβE΋_�t[�X`r�a�-T�C[x1t;��O٢1%wf�&X*�R��;���9�l�iq��p�y�SD�\���u�U/[�����}O�@��@��Uk��{�S'�*-P}�~ˬ������.�7 �1G�a�l�G�Zld��ܲ�
N������I ̬�[>PG����]r�أ���4ȵ�I>Ðb"��a�Xbi��/;ٗ��v��M
p=д74}����" %jp��.S,�ԅ��B߬"@����IDj	�¡7��&��J ����U7T�l�b��T��,T1ػWݳ���^��Bg����bՅ����u+uP�BY���`2@��#�Зμ���=�|��X�Y޾���� �҅i���'	L4�g�G~2�3�Ğ����7@4M�rX۔���8�ne�7�ޛdz�-_�@Jj�����#�R���z;�F�$��۵�s~�ǻ8(:�F���LJ�:���N�dL�u1�G %sr���>c�I&�}X{�x;c6������BX�͡�w���X\���V�}��,Q`����Dv7,m��(�	9C�O��CH'���N�(Ȩ�����o�2�j��3�n(Hs��0t�9�P�̳nwJ��@�Wɾ��(���	��x�
.E����k�.�̬����"�@�n`��Y�C�3.�4�]<%x�q�	~�xJ�묰`�cuJ q[���Y�;�Ͳ*�n:�.��sT�0  q���^�醳��ц�A �Xg��]���ц���4;s%7XXՔޖ)�!�᳂þ�8�&��}6���^���x�p}�����8C\�ͭz_n}�9�����R��"	R-��T�T"�F� .�l8�����-�FGK .�l�b��NA�0�Y�-�-P(.�:��*��R-&��йeV�ń0�.����R-&��~B�q����ݣ�lQ��q����>D@\�Ÿp1��T��B���o��3[����c���X���a�OA��P�^�}}�.�����W�����o~0���t����2���D�aA}�u�1Fи��ߖV�k>�?Lk�v6�	y� �Y��*���>.i��.Cs��f��C�����N���v�C��C+m��U����{�VZG�<%�_ˮ��a'�\��ܲ������	�7Ϫ�I�8)X�`��ݷ�Ƚ`/w�˳,u�Xٹ��`05`��^�A�ְ��殌%�t��g��,�޼HnA�f��)�����^�'�:�Sy����������h��Q�-��g��t�j��P��	��v2��P�@=i��ы�eo~e��,��O��PO2TZ��h(��@=>�޺Pe����P��JF/����C;g���2��7PO�g@��@?xVs��۶�����Ӷ�]=禷{t@.	�KJ�z��KB �����3���r/u�Q��k'_Les�v2/;�;g5E��CP���)A���<��s{����P7�&��֦��G0���>-�\��e q�ӻ�:�?:����ǟ����]���H��}���Z!�z��z���h|�e<�;%d� �]���]|و�pR]���H���[�^��Ej�O��e�V��w ��8�﹨�s�)-Ha4� R^��yE
�T�F��tQ��s���iQ�MH��,�R��O��)$��+��C��E���&�T�/Ha���m��o,�X�jK�'{�S�F¯�I��9w([p�������|��t$N�8�#�Ʈ[�dpƮ��ٟ��q�X{sCq2�T�������Ȫ/��te݇S'��v�����n��u�JJ�Ӹ/n��s;�q떁���dp#�`>r��̙׸� ����|����Ok���|ڞ�����d�4����d�4��7��d� ]�|��97������=
������)�Y7�?���L�ąG��hQ�Ӗ��o�����8~�9=OK�������8����8��
8q�yz�T8j�3tݪ�^�`V����3�j �^7���[�G�]
�� LQ�e>c��CdhR��3<:�ހ�l׮�q�P~��������)��,|0���>�N�g��|P.�Ԣc��`:%����[p >(���]7��j���<���`����?ŝ�`nb/�}Ⱦ��G��|�ܻ���H�A�PM��G�h�/T�����!_�6_���B5��|��{1?�<�Ts�������Ap&��#�����r���7������\���w�#��V�l�S�|���x���Fދ��������g�}U�8_�;��[p����}���Mۃ|���S��Ӎ��IC�>0����T���{�n�	�e�b�/��9��N�� ��t�Y��@|����ؑ7ނ�Af>C�-���҄c��?p�����m�9 >XnN8C� �B�gh >X�%M8Cϟ���y/�cq��3��F��;�>̓#�A1�������qCϹ|P<=�"�A�����'����~���O�Pމ���C�����n蹠x`�7��S����8�?�FO14o<i�̺d�j��Kۺ$w{�M���H��c�Q�;���� N���>���ߥ��rR1>�!�2�ڴ��1$�,cHO�5�l�p�7��bVsr�P`u�aOC�caً�y8�N:ʋ=�e�C��1x��e�5#�A����LC�u�Q�6˓�sw�1���4�Io��1����/�o��OY���U���3��{O����O�R� / �ã@���R�Mi5��̩�X;zR��i��Ϗ�iӺM��� 0��'�8)D��I�|��.����G���z�p�+r:)D/8��ۓ��y�꧜�58�E���u�G-���k�i���8	p��<�;��W���_�'��a���ݵʋ���>���gΔ[G��| w  ��^`�q�Ӿg��M����v�5���g��Oy�Koq�2����nt}�?�s�\���_.�|~jue��2�B��n ��%y���J�ǹ~�/��<�K���ɀN�?��PY|�n��Ps�y0n>��;p��8��K��SG�A>�\z7���S�iX�4=f1���	�\xG�aVh�	'Y��X�p�{:w�Yz��ԤHz�kǆ�$�M1�I#a2�T�0�X���4��H�
0i���^��Y��K-�:0���E��t��&�G�S�	��0��O��#a�ta�8X C6O#a�̢�����E���Ys{��L��5G��I�=���[s0��F�^�6����[}2�ݹh=�[�xfR��y�`�[���&�Z���y��o�i}[��k=�\�>8���*�� GX�	#@
j-b`�SHA�	t�� G������G��?0D����v6�qA^K��	��{�r���Y�2	r -�@��x�E`�/t�FnrD�{J�JО�TwիW-��FD=�4Ԉ� �ʭRI�'Qp�cR�����x�=����
a���eT	� ci��#��A�Ъ�	�0ං�ބ@����ntѰᆽ�{�Sy���{��W���a
(��Cu*p<(�Cu�0��[���L��*K��<qє��*�#uOX�1Y��Hu��iT@����K����<�æ*��z8|K��o5���0v�%sp�����ĝ�9oin�]��1)�FU:��n�d�<�J<c��z�xΰhJ��-�&�����<�<�by��H*�O�g`����#���	ݢ�@�%ˡ�Ml?�����Т9��er����~y}i�1.,7��|���&[ER��4-�͖��Ā�	�x2��wD��z�uLI-�6��I�HNH�z�"����5)!)$!/!�)��AEۈ�~���������//�=�<l��M{������������n~��̟�o�<Ο�^��L�B6tr��Lb���CoM"1ɽ��1)��DI�ɺ2�I����%�IL����YǄb�y�)k�I)Gk�Iꠞ����#A��H#��/��R��$I�c��L�� ��kv�B���X�T!�H��8+�G�]�:&�"MK����i!��b�'k�(�QR~����Y=Γw�Vo�^EZ�_���.Ny��*Rr�d�$��\H=�$��*	Fu@2^�J�Q &k�]I0�X���	�$V���V�ҁյ�'���ݨd72L�� �4"�\kjD�=Z{� �no!�?����p��c	�,�8�h�����:J�;JP	��!z��s�~����
���R�Fׇ��p�ո����jμ>D�#	�v21#j�����%	��I�R֮_	�ҭQ�EE�N4�r��g��ڌ�򶓾�>+��PG�>P�>ۣP:�~�7�AuJpu=;2&l�����x;�7��~9'�����빫�4�Н��s涋��/�,_���_��<��P����s_��U��e���+L��*Ѧ(G� ���	�u4GB9X@󽊄�`�Q	Q�
�>{BA��P��Ui�ux�t�
Uo޽q�u���<tS�!��w�8��/�u�oZ������n�m�}�c��.r��w�~Q��noo���
M         �  x��YKnG\���e�9�D�g��,H6`"�V��O Ō/ǿ8Ȑ"�?u��+�$���C�1`�Ȣ7�,���~��W�GnT*�ο��}��_o���Av�'~��K?�K?�:ο�s��!�/p�� �ǮZ/W�夒�\��JvZ���[0�ɺ�?�N`��`��]}�~��U��4�|�{tg~�p��]�.ܝ��
'�����an��DN��F���p�;�2�a%��x�K��
6ẓLۯy;;��9���u�p��)s�q�)w��p�3���)�fGJ�1J��:�[̯��Y�u�P�|�p~C���/O7�5c?DMO��Qa�R�=�<�{\[�fv�K�ۯ�>��f�ys�՘�����]�Tv\�ȃ����<����:,��)�;1�N><a�/3m�*�C�CUQE�"��qXvŤ�_ь�銸��|=���X�ʪ���bV�y���lv@$��#E���0d	O	+�a����.5�b ã�I	
������"�8 =�[�{��
cܧ�K�>8�V̯ ���LNh���9;+�F�ba��L_�z�����"=&�GY�c24T��_J�	�3S��V�u�q?av�g�
u��Ŋy	땸dc$U��5D�	c|�������)�W�F������n �͔~� z�e��b~/^����d�pS̔�,uS�8Q�9w�N��@��LS��UVm����n-���,,-SB�qr@J
%��j����;���B"8�5�%E�~��L�3�Yei:�J�r?��;��q���ݺ���J��Δ��z\0+�@2\)�;�Z9�K�%�/�#r�]k_1/5%)H�
��C]���A�g!��
p����2E6�\h.�Zֽ����N8L|f�B/K�j(���SQ
(O&�l)i6��
d����X��C�_��9�V�k�tM�;k�_�qL姛����V��%E��i'gQ���;8�������T��7�l�A��S��F9�I�0)8m�u�ƷR
(skR��a�&�v�Sd�c%��ޯ�(��y��1�f��q��F ��zM����/�g�ǻPK�~/?R� /1�1뫑���:Et�A����T�.�5�ئx��l
BOo�N����)£x�b��k�Q��r�aT{�i]�򒳜�Å�S�����G���9R�a\���yC�|�N�A^����˴h�"Ȭ�	!Z�)��.�6⻔�4�9�Hu,���M����]>���<뚪��:�\W�E��<S�90p�� ��I��`�r��	�1?�p�\�p�2�b��z�2a����?�����F��ݽG�����޽��޽��+&��Bv���v����=�5���91����@��y�jmm�j�����v�]�)|~a�U��p�ƿ�O���v�&-����W��~ܻi�C�w��ɼ�j�������o�	�w����Պ=<�֚�?WG�|!�0�u�ʞ��?�[I�ŧ�t3}f�>��|������O��A�<|��a��L�#>��}3��z5��$��Fm+��Z#&�ZL�7j���w�z��{=�_3Q�Wm굨�cj]��Du߬�#�O��z�D��v�7����m�f5��6&�Qi�D=Z�+qy��}�Hb�y��)9;��s��˿�a�2�9bVb���[�َzҏ;wc�`�S�� ��:j���8�_!�;�b���8         3  x�m�M�7���N����J�N���&���E�L�*��0�B�F�TU���,��J�jIOcx�>n�o� ,�lO�����A�{\����o����O�0���C:����E���ͻ�]W�RҪ����ۧ���[FkbU�&�ir��z�j�k����e����'%"�����ۿ�?�_��u����N��s��Z���p-<���q�K���]�P�V���1xF�Dp��;�H���/�?&G̕dOJ�Cej�ߚ\uČ��%/����"/j����g��8	g��t{KZ�}'���%��*�Z�k����8h܋��Ԉ��a�)�:-$9N"κ �=�qV�B�Wd�V���4�zP��Rp�ܩ�1�Y��
�'Zq�5��R��طu�k`�fV�Sc�9X�����S<j_�����˰ɷ��s�,�-�Ұշv��r	���|�aZ���*�*}+a�gy��U��V�q|E���T�f�V�������t�3PTNqAs��tu<Iv�*��qAd��:B�W7fZ�#��j���������Qۅۤ����d&�ӯ?��9�H��ZA��X�/|l��(o10r�jX��͛AׇhC�X���&5pDI u��G���=p>-A:%�_&���6LbR����N"Ouͫ��f&Y3���f@�@�P&�h�N��:��%".R
(�#�r�Vej&J&�J&H�D-ԉ���	f�ĭ­�-�A{�C����f�_J���c�N����}�%Jd�fTBLP��G�h�}A:%ek�g��'�c1P;Vf�M��5�-��on�
"h[����m�6Ǐ�b"���V��|CLgI��G�rX��Ԍ8(��D︇K�,��p�B�D��,m<�H�
')B?3���ydRQDI������90Es`E� fT�&"E�oڽ�9^��>'Ǜ�|�"�UW����}��Y$��QO@C�(x���B�ˁ)�B9�%�ȊI�*���Ua�n���L�{P�N8�
���h��`�Μ�U��$�!6B>s�P&O�N�?�?���	�K�^�]��_�����v�_��      �   �  x����n�@��y�"_pv!``3ĉmBT	c`lc;�*��۶ꪭT�OU��^����F=&M�d�ƚ�3��|�g$.���t�١�G�Y��&�Ȯ�Ov�z�~�N�ܥ6��ڦ23$��(<T�
�F~|lU�R6n�L۞*���ge{jڮ��tͩݩ	ȋ���@R��-o$��H�NQ`�'�S\�S�^
�NE�U�,cR������~��JV����{B��^�5#p�ݡ���r�[�a�l�p.6:F㴶_rS�oC7�m�t�8Q�����hjϢI!I�o�D^������xjg�ý�M�[�7��^���l�|u�.V����6q�%��pI��ˤ�ʘ>p��8-[�	f��dhS�'R3��U�ͮ߭����P�D��&�����h�S�t:8�x������V����wc�V/V�r�-��]ޢl�w��p�ʥ@�}�ӵY��T�21�t��"tw��uH��Qݲ;y���)HA |��2�q�c�i�w%8K�l�liJ�ќQ��ǃ^Swʧ	�z�v}�w�	R����+������(�nSu7y����7��0�d?��X�ΣK��ͣt$n$a�m  U0T��Փ��*�𕖧�����՛���"n���Qi�niY)���A×��2>H��Jc�/r3��&!��*��>pz�.!$�x~�Z_�ɹY��	���*��+���M���1��fɏ��h���s�N5-i�ƇY��@K�<U��Ri_������ �x'     