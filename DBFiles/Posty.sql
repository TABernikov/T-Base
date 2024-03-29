PGDMP         (                {            t-base    15.3    15.3 s    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16399    t-base    DATABASE     |   CREATE DATABASE "t-base" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "t-base";
                postgres    false            �            1259    16464 	   condNames    TABLE     n   CREATE TABLE public."condNames" (
    "condNamesId" integer NOT NULL,
    "condName" character varying(45)
);
    DROP TABLE public."condNames";
       public         heap    postgres    false            �            1259    16457    dModels    TABLE     u   CREATE TABLE public."dModels" (
    "dModelsId" integer NOT NULL,
    "dModelName" character varying(45) NOT NULL
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
       public         heap    postgres    false            �            1259    16410    tModels    TABLE     v   CREATE TABLE public."tModels" (
    "tModelsId" integer NOT NULL,
    "tModelsName" character varying(45) NOT NULL
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
       public          postgres    false    219    217    217    240    240    221    221    220    220    219    219    219    219    219    219    219    219    219    219    219    219    219    219    219    219            �            1255    16654    qqq()    FUNCTION     m   CREATE FUNCTION public.qqq() RETURNS public."cleanSns"
    LANGUAGE sql
    AS $$SELECT * FROM "cleanSns"$$;
    DROP FUNCTION public.qqq();
       public          postgres    false    222            �            1259    16547 
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
       public          postgres    false    229            �           0    0    accesNames_accessId_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."accesNames_accessId_seq" OWNED BY public."accesNames"."accessId";
          public          postgres    false    228            �            1259    17115    buildMatList    TABLE     f   CREATE TABLE public."buildMatList" (
    "buildId" integer,
    "matId" integer,
    amout integer
);
 "   DROP TABLE public."buildMatList";
       public         heap    postgres    false            �            1259    17100    builds    TABLE     k   CREATE TABLE public.builds (
    "buildId" integer NOT NULL,
    "dModel" integer,
    "tModel" integer
);
    DROP TABLE public.builds;
       public         heap    postgres    false            �            1259    16568 	   deviceLog    TABLE     �   CREATE TABLE public."deviceLog" (
    "logId" bigint NOT NULL,
    "deviceId" bigint NOT NULL,
    "eventType" integer NOT NULL,
    "eventText" text,
    "eventTime" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "user" integer
);
    DROP TABLE public."deviceLog";
       public         heap    postgres    false            �            1259    16583    eventTypesNames    TABLE     z   CREATE TABLE public."eventTypesNames" (
    "NamesId" integer NOT NULL,
    "eventName" character varying(45) NOT NULL
);
 %   DROP TABLE public."eventTypesNames";
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
       public          postgres    false    231    231    231    231    231    215    215    231    233    233            �            1259    17090    matTypeNames    TABLE     l   CREATE TABLE public."matTypeNames" (
    "typeId" integer NOT NULL,
    "typeName" character varying(45)
);
 "   DROP TABLE public."matTypeNames";
       public         heap    postgres    false            �            1259    17129    mats    TABLE     �   CREATE TABLE public.mats (
    "matId" integer NOT NULL,
    name character varying(45),
    "1CName" character varying(45),
    amout integer DEFAULT 0,
    "inWork" integer DEFAULT 0,
    type integer
);
    DROP TABLE public.mats;
       public         heap    postgres    false            �            1259    17149 	   cleanMats    VIEW     
  CREATE VIEW public."cleanMats" AS
 SELECT mats."matId",
    mats.name,
    mats."1CName",
    mats.amout,
    mats."inWork",
    "matTypeNames"."typeName" AS type
   FROM (public.mats
     LEFT JOIN public."matTypeNames" ON ((mats.type = "matTypeNames"."typeId")));
    DROP VIEW public."cleanMats";
       public          postgres    false    245    241    245    241    245    245    245    245            �            1259    16514    orders    TABLE     �  CREATE TABLE public.orders (
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
       public          postgres    false    225    225    225    225    225    225    225    215    215    225    225    225    225    225    225            �            1259    16535 	   orderList    TABLE     /  CREATE TABLE public."orderList" (
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
       public          postgres    false    217    227    227    227    227    227    227    227    217            �            1259    16636    wearByTModel    VIEW     �   CREATE VIEW public."wearByTModel" AS
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
       public          postgres    false    238    217    221    238    238    238    238    221    217            �            1259    16567    deviceLog_logId_seq    SEQUENCE     ~   CREATE SEQUENCE public."deviceLog_logId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."deviceLog_logId_seq";
       public          postgres    false    231            �           0    0    deviceLog_logId_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."deviceLog_logId_seq" OWNED BY public."deviceLog"."logId";
          public          postgres    false    230            �            1259    16582    eventTypesNames_NamesId_seq    SEQUENCE     �   CREATE SEQUENCE public."eventTypesNames_NamesId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."eventTypesNames_NamesId_seq";
       public          postgres    false    233            �           0    0    eventTypesNames_NamesId_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."eventTypesNames_NamesId_seq" OWNED BY public."eventTypesNames"."NamesId";
          public          postgres    false    232            �            1259    17128    mats_matId_seq    SEQUENCE     �   CREATE SEQUENCE public."mats_matId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."mats_matId_seq";
       public          postgres    false    245            �           0    0    mats_matId_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."mats_matId_seq" OWNED BY public.mats."matId";
          public          postgres    false    244            �            1259    16534    orderList_orderListId_seq    SEQUENCE     �   CREATE SEQUENCE public."orderList_orderListId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."orderList_orderListId_seq";
       public          postgres    false    227            �           0    0    orderList_orderListId_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."orderList_orderListId_seq" OWNED BY public."orderList"."orderListId";
          public          postgres    false    226            �            1259    16513    orders_orderId_seq    SEQUENCE     }   CREATE SEQUENCE public."orders_orderId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."orders_orderId_seq";
       public          postgres    false    225            �           0    0    orders_orderId_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."orders_orderId_seq" OWNED BY public.orders."orderId";
          public          postgres    false    224            �            1259    16418    sns_snsId_seq    SEQUENCE     x   CREATE SEQUENCE public."sns_snsId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public."sns_snsId_seq";
       public          postgres    false    219            �           0    0    sns_snsId_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public."sns_snsId_seq" OWNED BY public.sns."snsId";
          public          postgres    false    218            �            1259    16409    tModels_tModelsId_seq    SEQUENCE     �   CREATE SEQUENCE public."tModels_tModelsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."tModels_tModelsId_seq";
       public          postgres    false    217            �           0    0    tModels_tModelsId_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."tModels_tModelsId_seq" OWNED BY public."tModels"."tModelsId";
          public          postgres    false    216            �            1259    16400    users_userid_seq    SEQUENCE     �   CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.users_userid_seq;
       public          postgres    false    215            �           0    0    users_userid_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;
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
       public          postgres    false    219    219    225    219    219    225            �            1259    16509    wearByPlace    VIEW     �   CREATE VIEW public."wearByPlace" AS
 SELECT sns.place,
    sns.name,
    count(sns."snsId") AS count
   FROM public.sns
  WHERE (sns.shiped = false)
  GROUP BY sns.place, sns.name
  ORDER BY sns.place, sns.name;
     DROP VIEW public."wearByPlace";
       public          postgres    false    219    219    219    219            �           2604    16550    accesNames accessId    DEFAULT     �   ALTER TABLE ONLY public."accesNames" ALTER COLUMN "accessId" SET DEFAULT nextval('public."accesNames_accessId_seq"'::regclass);
 F   ALTER TABLE public."accesNames" ALTER COLUMN "accessId" DROP DEFAULT;
       public          postgres    false    228    229    229            �           2604    16571    deviceLog logId    DEFAULT     x   ALTER TABLE ONLY public."deviceLog" ALTER COLUMN "logId" SET DEFAULT nextval('public."deviceLog_logId_seq"'::regclass);
 B   ALTER TABLE public."deviceLog" ALTER COLUMN "logId" DROP DEFAULT;
       public          postgres    false    231    230    231            �           2604    16586    eventTypesNames NamesId    DEFAULT     �   ALTER TABLE ONLY public."eventTypesNames" ALTER COLUMN "NamesId" SET DEFAULT nextval('public."eventTypesNames_NamesId_seq"'::regclass);
 J   ALTER TABLE public."eventTypesNames" ALTER COLUMN "NamesId" DROP DEFAULT;
       public          postgres    false    233    232    233            �           2604    17132 
   mats matId    DEFAULT     l   ALTER TABLE ONLY public.mats ALTER COLUMN "matId" SET DEFAULT nextval('public."mats_matId_seq"'::regclass);
 ;   ALTER TABLE public.mats ALTER COLUMN "matId" DROP DEFAULT;
       public          postgres    false    244    245    245            �           2604    16538    orderList orderListId    DEFAULT     �   ALTER TABLE ONLY public."orderList" ALTER COLUMN "orderListId" SET DEFAULT nextval('public."orderList_orderListId_seq"'::regclass);
 H   ALTER TABLE public."orderList" ALTER COLUMN "orderListId" DROP DEFAULT;
       public          postgres    false    226    227    227            �           2604    16517    orders orderId    DEFAULT     t   ALTER TABLE ONLY public.orders ALTER COLUMN "orderId" SET DEFAULT nextval('public."orders_orderId_seq"'::regclass);
 ?   ALTER TABLE public.orders ALTER COLUMN "orderId" DROP DEFAULT;
       public          postgres    false    224    225    225            �           2604    16498 	   sns snsId    DEFAULT     j   ALTER TABLE ONLY public.sns ALTER COLUMN "snsId" SET DEFAULT nextval('public."sns_snsId_seq"'::regclass);
 :   ALTER TABLE public.sns ALTER COLUMN "snsId" DROP DEFAULT;
       public          postgres    false    219    218    219            �           2604    16499    tModels tModelsId    DEFAULT     |   ALTER TABLE ONLY public."tModels" ALTER COLUMN "tModelsId" SET DEFAULT nextval('public."tModels_tModelsId_seq"'::regclass);
 D   ALTER TABLE public."tModels" ALTER COLUMN "tModelsId" DROP DEFAULT;
       public          postgres    false    216    217    217            �           2604    16500    users userid    DEFAULT     l   ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);
 ;   ALTER TABLE public.users ALTER COLUMN userid DROP DEFAULT;
       public          postgres    false    215    214    215            �          0    16547 
   accesNames 
   TABLE DATA           ?   COPY public."accesNames" ("accessId", "accesName") FROM stdin;
    public          postgres    false    229   �       �          0    17115    buildMatList 
   TABLE DATA           C   COPY public."buildMatList" ("buildId", "matId", amout) FROM stdin;
    public          postgres    false    243   x�       �          0    17100    builds 
   TABLE DATA           ?   COPY public.builds ("buildId", "dModel", "tModel") FROM stdin;
    public          postgres    false    242   ��       �          0    16464 	   condNames 
   TABLE DATA           @   COPY public."condNames" ("condNamesId", "condName") FROM stdin;
    public          postgres    false    221   ��       �          0    16457    dModels 
   TABLE DATA           >   COPY public."dModels" ("dModelsId", "dModelName") FROM stdin;
    public          postgres    false    220   ��       �          0    16568 	   deviceLog 
   TABLE DATA           i   COPY public."deviceLog" ("logId", "deviceId", "eventType", "eventText", "eventTime", "user") FROM stdin;
    public          postgres    false    231   ,�       �          0    16583    eventTypesNames 
   TABLE DATA           C   COPY public."eventTypesNames" ("NamesId", "eventName") FROM stdin;
    public          postgres    false    233   *~      �          0    17090    matTypeNames 
   TABLE DATA           >   COPY public."matTypeNames" ("typeId", "typeName") FROM stdin;
    public          postgres    false    241   �~      �          0    17129    mats 
   TABLE DATA           N   COPY public.mats ("matId", name, "1CName", amout, "inWork", type) FROM stdin;
    public          postgres    false    245   c      �          0    16535 	   orderList 
   TABLE DATA           s   COPY public."orderList" ("orderListId", "orderId", model, amout, "servType", "srevActDate", "lastRed") FROM stdin;
    public          postgres    false    227   �      �          0    16514    orders 
   TABLE DATA           �   COPY public.orders ("orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName") FROM stdin;
    public          postgres    false    225   ��      �          0    16419    sns 
   TABLE DATA           �   COPY public.sns ("snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder") FROM stdin;
    public          postgres    false    219   ʉ      �          0    16860 
   snscomment 
   TABLE DATA           6   COPY public.snscomment ("snsId", comment) FROM stdin;
    public          postgres    false    240   �_      �          0    16410    tModels 
   TABLE DATA           ?   COPY public."tModels" ("tModelsId", "tModelsName") FROM stdin;
    public          postgres    false    217   �f      �          0    16401    users 
   TABLE DATA           P   COPY public.users (userid, login, pass, email, name, access, token) FROM stdin;
    public          postgres    false    215   �j      �           0    0    accesNames_accessId_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."accesNames_accessId_seq"', 1, false);
          public          postgres    false    228            �           0    0    deviceLog_logId_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."deviceLog_logId_seq"', 1013, true);
          public          postgres    false    230            �           0    0    eventTypesNames_NamesId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."eventTypesNames_NamesId_seq"', 1, false);
          public          postgres    false    232            �           0    0    mats_matId_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public."mats_matId_seq"', 6, true);
          public          postgres    false    244            �           0    0    orderList_orderListId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."orderList_orderListId_seq"', 5, true);
          public          postgres    false    226            �           0    0    orders_orderId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."orders_orderId_seq"', 50, true);
          public          postgres    false    224            �           0    0    sns_snsId_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."sns_snsId_seq"', 6956, true);
          public          postgres    false    218            �           0    0    tModels_tModelsId_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."tModels_tModelsId_seq"', 2, true);
          public          postgres    false    216            �           0    0    users_userid_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.users_userid_seq', 3, true);
          public          postgres    false    214                       2606    16552    accesNames accesNames_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."accesNames"
    ADD CONSTRAINT "accesNames_pkey" PRIMARY KEY ("accessId");
 H   ALTER TABLE ONLY public."accesNames" DROP CONSTRAINT "accesNames_pkey";
       public            postgres    false    229                       2606    17104    builds builds_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.builds
    ADD CONSTRAINT builds_pkey PRIMARY KEY ("buildId");
 <   ALTER TABLE ONLY public.builds DROP CONSTRAINT builds_pkey;
       public            postgres    false    242                       2606    16468    condNames condNames_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."condNames"
    ADD CONSTRAINT "condNames_pkey" PRIMARY KEY ("condNamesId");
 F   ALTER TABLE ONLY public."condNames" DROP CONSTRAINT "condNames_pkey";
       public            postgres    false    221                       2606    16461    dModels dModels_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."dModels"
    ADD CONSTRAINT "dModels_pkey" PRIMARY KEY ("dModelsId");
 B   ALTER TABLE ONLY public."dModels" DROP CONSTRAINT "dModels_pkey";
       public            postgres    false    220                       2606    16463    dModels dModels_unic 
   CONSTRAINT     [   ALTER TABLE ONLY public."dModels"
    ADD CONSTRAINT "dModels_unic" UNIQUE ("dModelName");
 B   ALTER TABLE ONLY public."dModels" DROP CONSTRAINT "dModels_unic";
       public            postgres    false    220                       2606    16575    deviceLog deviceLog_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_pkey" PRIMARY KEY ("logId");
 F   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_pkey";
       public            postgres    false    231                       2606    16588 $   eventTypesNames eventTypesNames_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."eventTypesNames"
    ADD CONSTRAINT "eventTypesNames_pkey" PRIMARY KEY ("NamesId");
 R   ALTER TABLE ONLY public."eventTypesNames" DROP CONSTRAINT "eventTypesNames_pkey";
       public            postgres    false    233            �           2606    16408    users login_unic 
   CONSTRAINT     L   ALTER TABLE ONLY public.users
    ADD CONSTRAINT login_unic UNIQUE (login);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT login_unic;
       public            postgres    false    215                       2606    17094    matTypeNames matTypeNames_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public."matTypeNames"
    ADD CONSTRAINT "matTypeNames_pkey" PRIMARY KEY ("typeId");
 L   ALTER TABLE ONLY public."matTypeNames" DROP CONSTRAINT "matTypeNames_pkey";
       public            postgres    false    241                       2606    17154    mats mats_1CName_name_key 
   CONSTRAINT     `   ALTER TABLE ONLY public.mats
    ADD CONSTRAINT "mats_1CName_name_key" UNIQUE ("1CName", name);
 E   ALTER TABLE ONLY public.mats DROP CONSTRAINT "mats_1CName_name_key";
       public            postgres    false    245    245                       2606    17134    mats mats_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.mats
    ADD CONSTRAINT mats_pkey PRIMARY KEY ("matId");
 8   ALTER TABLE ONLY public.mats DROP CONSTRAINT mats_pkey;
       public            postgres    false    245                       2606    16540    orderList orderList_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_pkey" PRIMARY KEY ("orderListId");
 F   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_pkey";
       public            postgres    false    227            	           2606    16523    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY ("orderId");
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    225            �           2606    16874    sns sn 
   CONSTRAINT     ?   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sn UNIQUE (sn);
 0   ALTER TABLE ONLY public.sns DROP CONSTRAINT sn;
       public            postgres    false    219                       2606    16430    sns sns_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_pkey PRIMARY KEY ("snsId");
 6   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_pkey;
       public            postgres    false    219                       2606    16866    snscomment snscomment_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.snscomment
    ADD CONSTRAINT snscomment_pkey PRIMARY KEY ("snsId");
 D   ALTER TABLE ONLY public.snscomment DROP CONSTRAINT snscomment_pkey;
       public            postgres    false    240            �           2606    16415    tModels tModels_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."tModels"
    ADD CONSTRAINT "tModels_pkey" PRIMARY KEY ("tModelsId");
 B   ALTER TABLE ONLY public."tModels" DROP CONSTRAINT "tModels_pkey";
       public            postgres    false    217            �           2606    16417    tModels tModels_tModelsName_key 
   CONSTRAINT     g   ALTER TABLE ONLY public."tModels"
    ADD CONSTRAINT "tModels_tModelsName_key" UNIQUE ("tModelsName");
 M   ALTER TABLE ONLY public."tModels" DROP CONSTRAINT "tModels_tModelsName_key";
       public            postgres    false    217            �           2606    16406    users users_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    215            )           2606    17118 &   buildMatList buildMatList_buildId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."buildMatList"
    ADD CONSTRAINT "buildMatList_buildId_fkey" FOREIGN KEY ("buildId") REFERENCES public.builds("buildId");
 T   ALTER TABLE ONLY public."buildMatList" DROP CONSTRAINT "buildMatList_buildId_fkey";
       public          postgres    false    242    3351    243            *           2606    17140 $   buildMatList buildMatList_matId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."buildMatList"
    ADD CONSTRAINT "buildMatList_matId_fkey" FOREIGN KEY ("matId") REFERENCES public.mats("matId") NOT VALID;
 R   ALTER TABLE ONLY public."buildMatList" DROP CONSTRAINT "buildMatList_matId_fkey";
       public          postgres    false    3355    245    243            '           2606    17105    builds builds_dModel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.builds
    ADD CONSTRAINT "builds_dModel_fkey" FOREIGN KEY ("dModel") REFERENCES public."dModels"("dModelsId");
 E   ALTER TABLE ONLY public.builds DROP CONSTRAINT "builds_dModel_fkey";
       public          postgres    false    220    3331    242            (           2606    17110    builds builds_tModel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.builds
    ADD CONSTRAINT "builds_tModel_fkey" FOREIGN KEY ("tModel") REFERENCES public."tModels"("tModelsId") NOT VALID;
 E   ALTER TABLE ONLY public.builds DROP CONSTRAINT "builds_tModel_fkey";
       public          postgres    false    242    217    3323            $           2606    16576 !   deviceLog deviceLog_deviceId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES public.sns("snsId");
 O   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_deviceId_fkey";
       public          postgres    false    231    3329    219            %           2606    16589 "   deviceLog deviceLog_eventType_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_eventType_fkey" FOREIGN KEY ("eventType") REFERENCES public."eventTypesNames"("NamesId") NOT VALID;
 P   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_eventType_fkey";
       public          postgres    false    231    3345    233            &           2606    16594    deviceLog deviceLog_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_user_fkey" FOREIGN KEY ("user") REFERENCES public.users(userid) NOT VALID;
 K   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_user_fkey";
       public          postgres    false    231    215    3321            +           2606    17135    mats mats_type_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mats
    ADD CONSTRAINT mats_type_fkey FOREIGN KEY (type) REFERENCES public."matTypeNames"("typeId") NOT VALID;
 =   ALTER TABLE ONLY public.mats DROP CONSTRAINT mats_type_fkey;
       public          postgres    false    245    241    3349            "           2606    16619    orderList orderList_model_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_model_fkey" FOREIGN KEY (model) REFERENCES public."tModels"("tModelsId") NOT VALID;
 L   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_model_fkey";
       public          postgres    false    227    217    3323            #           2606    16541     orderList orderList_orderId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public.orders("orderId");
 N   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_orderId_fkey";
       public          postgres    false    227    3337    225            !           2606    16524    orders orders_meneger_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_meneger_fkey FOREIGN KEY (meneger) REFERENCES public.users(userid) NOT VALID;
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_meneger_fkey;
       public          postgres    false    3321    215    225                       2606    16474    sns sns_condition_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_condition_fkey FOREIGN KEY (condition) REFERENCES public."condNames"("condNamesId") NOT VALID;
 @   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_condition_fkey;
       public          postgres    false    219    3335    221                       2606    16469    sns sns_dmodel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_dmodel_fkey FOREIGN KEY (dmodel) REFERENCES public."dModels"("dModelsId") NOT VALID;
 =   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_dmodel_fkey;
       public          postgres    false    220    3331    219                       2606    16529    sns sns_order_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_order_fkey FOREIGN KEY ("order") REFERENCES public.orders("orderId") NOT VALID;
 <   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_order_fkey;
       public          postgres    false    3337    225    219                        2606    16431    sns sns_tmodel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_tmodel_fkey FOREIGN KEY (tmodel) REFERENCES public."tModels"("tModelsId") NOT VALID;
 =   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_tmodel_fkey;
       public          postgres    false    217    219    3323                       2606    16553    users users_access_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_access_fkey FOREIGN KEY (access) REFERENCES public."accesNames"("accessId") NOT VALID;
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_access_fkey;
       public          postgres    false    3341    215    229            �   O   x�3�tL����2�0�bÅ}v\�~a��r��b��e�ya�]v_�pa�1�9�^��[.l���bW� �*(�      �      x������ � �      �      x������ � �      �   ;   x�3�0I�bÅ6^�w���V.C�/컰,���>.#�s/lU�؈"���� ��#}      �     x�e�]r�6��/��QM������f��8��T��⺤.� HY ���:�Dс/o�~���ꛋ|ܩ$���F\S&psՒ�W�fr�8���/;���^�o�t���pp�y �V�3���X(B5��������.�C�DM�b���a�]u�*�<�X&FͪE���1
~Fr_�c�g�	)H�\���)i"��<#2����Zvw�M�ˢ�e��ϐd�菻�a"�3��A�/;1A��Ţ59���h�+%P�R�ɗz��=K�h�3Ń!�$�+�l45-�W����Mi/.{�V�� 	雀Zo.��<�;�rr� O����,F���ك��R��o��
hHE�5�)����s�~u%Yp:�y}w%O��X���:1�6�V�V?1�V�y+j���,�fqb�,M���!Ұ�X ��ĸY�5k^������pb��C\�cY\��ky,�5ʸ=z��*������#�^�,B�� j� ��� ��>Npe�4|���ay�:+���j��u�2��>���/�wg�!��.�{Z��������)��J_�F��^>%5��h֔ˊ���O�w	�Bh��~��ú��]�H�>j,�S~��OEO �P��� ���K�Sqi*Q)�mCW�7I>�^?z����Zc_#w�C�j��	�pN>�X���@T
�H��m��*� <�	��D� A �౗����. Ŏ�)N���Ab'e'��>�nh��sFy�G�+
E����8TՓ��}y��+Cu_�}|i����`�+���X.��d̒q�}���4GKv�������ܳ_/�]��J���UhS��Q(ހ%
��D%�K	��K< �4d�w��x��[[���������~EBmG�?���c~nϢ
�5=�ʝVz	kК�h�sAҚzTjy��Sh7�bPcT5
�gk3(j=�E��� ��P�ĽZ0HzE��d���I��Q��#}Q��AdD�5�\����J��A�Q4H�'����?֟���[����8���_�~w��Z���      �      x�����5�q�7^��=��<g��{��v�����q�4`XB��:P44�IH�y�#��֗Y��,C�6E)��V՛�8d�v������������?�����������������7~����/n��vw�-�^�%ܼ���o��������0�����������?�Y��K��*�|b�ԭ|�Zu��Ԫ�*I�*��O�`%}u�V.H���OX=��K��Å�I����.����
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
1L��6��ꦆ�6,ی���Z�LA�M���l3�n��<�Ȳ�h��)��^�U7M!ow�f4T���f�u���ꦆ�]�ck�n���8ߛق��Z� ([�PuSCk�B��6T�4����lA�M-�[�mmC�MmV8��U7M>����T���f{�PuSC�0�mC�MS�o�����ꦆ6�ۆ���T��ۆ��2��KX�ۆ*�R�糙-��i�a��bo�pjhe:���U8Mt.�_j{�P�uS|�lk�n�h��䵭m����5O�ck�n�b�&�Y�*�&���k3KPeSCk>��m��i�oa��m�����	f����Vg@�6��ʦ���f��ꦉ�,?�lc�n�(j���6��� �  �6���U6M��y��}m�����2�Y�*�Z��{�kC�M�=2&A�T�4�2�h��U65��llC�MS��{��Pe������m����u/�gg�l�(�v[��ͮЪ1�5f:䶷��\������j��y�����T{Ƚ{�[�T��.��B��-\�z��y��v8��Mb�6g��*��2s#��M5�r�yE�-��T�xNe����&
��w�K;�#A ��S�+��뿎�d�
��d��ŧH$\�q�~>$�ձ�V�B�䢻>v̼��8�فz4uȃ+d��nƩ墻J6��E�\�H`�|��s���e�Tt��R������.��\�~c���n�Y`�w~���g���/ٰ-�y��v����[��an���P�����k����6���o�o����L-�T{9���]Ӿ����T�=      �   �   x�mO��@�o�p �C��!��b��DD�[XXFw5�v��V�̣��A%��r�!�'���ƃ��?�&Jf�RHIӯ�A@�V'�ݫc�я��>���M�I����UǷ�}�(hU�Ӽ�����Ŵ��;Z�����V]����~��/�iHD�      �   s   x����@��*� 	c���/@"%@D`�N�磅َ��p��[�h�ތ^���C�U�Z92�"j���/����*xF�{&��83E��^mu*w:�(�~��3�Q7      �   �   x�3�0�¾��_l�بp����;.l���b���.��sa���;.6%�+�j������t�LuM,�M.l�5�0�� �I5��ن`�u��&�j�V��`��0��b�	�N,N,.�:͌t�p�1z\\\ ����      �   �  x���[�� E�a���Bⵖ��l�ӝL۷�]��#8BOILIk��J�R�W!{�'�Wi��Au	-�ܜ3�=��T%�=:��&����J�Ϝ�F����钾�ؖX�8�Hy{o[��l�2����+�g�c�TGC�d��$��/��j�n4����X�ظ����$y�����o�%�t�7�3�t����h����:(����K{6П~�ޓmj��`�lwVzj ;�=�R�����t��� ���4��B�r�,�Z��C�������l�ܲ��`��Y��ۜ�N�X��{zaX:� �W%��v���(ܳK�h����?ܗ�l�{��|����`9���7�xO���U#��������/!�vgmQ:���3w�E�Vd�u�l��(X]U�����{z}o�2d%/�>�K�ۢ���ja�,����Vˢ�U����{��	��1���pe��V��Kѯ���� Y\V�u��L]�QԷh�|��h��'�trI�I[6+@sд��%-AW(�t�S�=��w��-�ރ�i�8i/�E >t�gQ��{���{<|�v�n�:;K�䇦{<�Σ���at
��R*g+��C*y�F����U ~n��׷�(�o����<���P�͕ { AՍ3��n�B�<�^�r��zGt��W1�c뵖Ѐx��k�~
2`V� 2`n�s�mPݙ[�Z��~TJ�����^�\v�����
(+��s���@e�p*�(�l���ns=`+�bԠ[2֡�l˶�!~[F2�+�Ac;�J8$���`�� x�U�Cn4O
��� �OQX�v�uI3�R[wz�f��{�_�~��5^�0��?�2��n�[�!����aw_�n���h����� ��a׿�@�ݛv@ېC�����]!�Jv��lt	��9?��B�#aW�<r�"r+��I�m%��G͓glm­���]���jkG�Y~�=K��ƥ��X�x�U���P��Ej���q���u�j�U�4���p�`�!׎��'��9�!-��\�)BmEw�(�5�6� ��ׂ���۰#��];�Bs�~�@�j���ju��ێuD�;y=�GU_�{��EJ���')�������E?�*S�1G)�x���_EB�H      �   #  x��W�n�F}�~��O�]rI�T�������)�p�l�8m�ȁ_t���(Q������Q�e��͕k���;{v.gƉc�y��E��D�	�O��%�x��E凲�׬�^<^Ie�i���F��)R٥*��S�:���|�)�Q�N(�x��A�N�3�kj�vf�/)����q�P��?H�5��I��Wj�r�Y1Rg��5l{�����On�	���=5hϥ=��:8Sj_�t]�T����]�{����=���%�v���~@ڧ���@����;U�iс�mw����k���h�F�z'�-�t�}bK�c|e�>��I_�(�t���G�z�y|y^�.����|���G_k��WS����0,L�p���-�`G��m_:8!N��!��>�k�S[��lr��~{��d�+c��b�=����Y1kz�`Ѿ��'j;�x	�T��4�N*�C a3�_q'"��Ӕ8#��B~��96{�y����7�ɁuO6�Ɛ]��L�5f��ל�eLs����(�H��,h{��C{��/;X��/ s;���-/�ik�#;��`�b�v�9
��L<�N1�>�Y�Jl�;٧��^Lk�:���� u�s9�q��7a�=�
�+�� �� �>ذɜ�) ���3��YR�n�	Q¸)	�(ǩu��h����-kr�̍��ǡ�'����Pa6�
Ug�,:K2ݥ�zlΞ튫m)>�ꉋ�����-*�� Gf/y�)��a��>�"y���xC<���S1I�YXX`�73�s�k��ϯ�)�T����Ł8d�|�s;lq5|���朔e$�_,�j�
�	���j@y��9B�~g��*��w�������e=6�P�x��4Ro#�Q��

<�L5-�qC»�!4����<]���.���o}��	V��c�Ka�E�Yt�'���b�p���iǻ�桦�0�sa�",��cS���rC�&��>y�veL�1A_��~;�km3U֙1%l7��oJ�AÁUc��qU�������(�WjR��ӛ�HW%�e�1ʟ�GF?�1W��#��C��+i�8���I�Mx)]D��6��pvE[pC]�dR��ٕ42\�DU~���
3V�6�#�����pg�qV���ˏ��7��&�O��:��E��'>�=Nj?����u�����!p���&9UR�L�ʞ� 냡�:΃_��������t��h�y��mdX��N�EטR��y�������ʏ?/�ܢ�iNo;>���R�_��1�      �      x�̽ۮ%�q%���+z�r����4�{�sH��i���&��� ^4� B�(���L���,����v��xD�nkgV�Gs;�*Y��X��f��͗[�����_����/��.�y��o�����꿿7�{���W�w���_��5Y2��|��'�����)�m���9���W�ym��s�K�:��|o��7�:\���ٛ�����&s�ͫ�K������>������i/�}ܪ������ܫ�����x|<*���>��7��s6�)fk�7ӳNt<����\~4�N���哏�|��z}���mR�	�
q����ߤ�7�+�5*�Ce>**�JC�
e����_�%��+����*�;,�ď��ˏ7=����M��a�4�a�lGk�4q��Ɵ�ѝ��W���X_a���u�f����?�/�/�;�:�iH_s���X��*V�ֺF�-�˧+T]$ױB��7G*�\��Gʆ��N���.��ɫ����E "tJ�+�=M��!�J.S��kC�����F�A���k+�m�[X~�.�r�N�:V����!]�ܜ��̡���{�ېl���k���P�J1W7�]�9l1�l��s=��
q����m�,^V��ʤie.?���ۗ�]~]���}<|���7Ȗ	��@c.Ogs�3�0��W�]0�����|�/���@3!��P�N����x�wAQT�a��o�G6M1#�kа����G5'<xϡ|~Ǩ�!Y�J+�Q�l��%|��P��Fu>�����y�kP�.O`�Q%6�$*��ʾjY�صV	������P�/�tː�3���*M)�y���G��،Lc�K���9O�R2]�Y=��iV�p�d}ߎ��7�y�����K�A��YN���@4��M��r8���kx�&��[�x�⹠�����M>f�Et��\*;.86�'�;�òm��̱�����v���q��P"s��S���%�5��5�p�&��u�.��ۃ�!�N�O.�^~����/�p�����=E�T��8A�t8�����������	�(�ۻ.D����F�SP��� )4$�?�>$H�!I�)p���oH��#Ůu��dV$�$m�#���ԇ��f��i��9�7,}����� kWXz�Jo ��I/�G�h�f�4ҍ0�}WtW�dN�i�:6p�ɦᜅ��{��JC:J#@��g�zV)RbH��� ņ� ���Y^�C����aypl���F QC��]���7I߀���)� ������$`�ȼ)J#��E���!"��(m���Yy��!6?J3Q ��Ə;bSR�-b���!<C:
�m��͛�;�	"�u�0�o�t�o�� ��f�%H�0Df~+ͯ��EIz��#�YDّ�v�k�9"�7���p�)���g6r�Q_��w���KZ�fn,��Z53����捆0����	��J���c��²`�n�y>�ٮ�8�v����X 0j`f�4F 3l��Xci�8�@2�Nu�q �Y���`�Ә�&�f� �302`����9 �L�30HjNM'yk�� �0�#�ͩ} �x��_C̎xVY:J�"�R餱� 7���j���g�S8�~��̹�c��ѷI�AV��X����6&�X ��:�;�&��Km��bF8l"��zoݸx����% VhXGy�X�a�]X]�\I ��ڙ=kw�[F��"s5�,� �PUՔ��Qe�������"C|PTؠ�Ɋ���bv���wPb@�fA�c��1sË� cPc�㎘ً�A�1���X�$B��Yh��&ޏ�l�i.l�F�aٶ\���b�3 yk�ē7"��F�䭞�7�zY_& ߀�V:Hox�w$��X@��;�^,����y?�obmxf����X�gx�wl1{��7<�A����"�l�a����'�=3Y����~5��*5ϕ�V��p�0��Z[8�;J{�i��p,{��X�����Y��1��a�`����Q�4p[����z���"3 �9�
�(\�;w��Ru���By�/�-I�Ӌ���䮅��#��Q\i�z�O/?���-4h���N���&	m؈��T�A��>�ج;{?TdP1�Q�Ǟm»�fb��]~}�����7߽|v��[�	p�o���!n�F5�4�Q�@�y�|���渵5��ŊTS²"M~�H�\�&�}u�Ó9��P�\{�D�Ô�j�^~���t݋�y��I�)Ѱ���j�cۙ�"���E�Ǳ����_�m0<�m�q�?�Ǳ�Z���n08Mə�ɇ2�e�v�~p���A� 0`�hY�F���C�����]1AǓl���1�V޺]�H��Jy&_3��5$�������-0���d#��p��Bjshj���aL��9{ۂ�#��*��J�}FX�m�l��k(��H`��Ya'R�F<�mw�*:�P�q��먢9��{��RX��^�M���A�P�K9R��V$i��܃)�P~��n�[�̍=2���=n��?8aF��m*����O�PEs*��y��M7Q�)�uGr)1��
 {� �gf]>5�յyB�r� )5�^Jﶽ�G����i$J6sa��&A��M�����&���Y��2�Db4!<�R+�T�H#AF���N��Gr��r��$=&HM����<��1Yi$�Y�ܟ�+7+@�70���y�\�؞�4�[C�d�TҎL��'���]M���bWZV<�Gj��
�͑�F&��Q�鴏a`-�=�W�o�����?���Z�X���[XXD�Z��d�$�,��+[�!��r�/����]��S���������2���b����n�V�����C����m0��������m0�\;�Ff�M�� ���?��0�m��B+�1�h����
�A��x�ݛ6���!��ف]��/t�"EB�`Y���f�L�i�0�`R;+��H������@�X5Wx?i		#6� �ݦ�τa�qӝ�%&?�8%6��p$���Qm�zب1�ETh���d|�ڊ.�> �[r�؀���6�sYp���S�O��f,5�� 0Ǘ*7�Y�%�TF�ۨ�FشDW����i�n����H
�af��7tn9�"'�Mv��,?���= �l�][���IN��Ȍ-J�m������[�GY�s���뀒�6�A�F��:����<{�|��ym+���a��S'�w#@jF���7!��u��d٘�� 96�~��C�aRS"i$�&�&�g�`"jLde��s�ȫ���0���ިh�"�Ν��[�mvn�!Hz"5sH���9$ ��&�IODJIzL@��a��F		�0$�� r�i�$R0��H/
�r�܈<u�*;�) E$6{��׌�	�[�IzH�(3.��k� `����\" 9�d�� �7������\ڈ|o��9��	������Hr�R���("BQ"�=a2���NK��sD��]7��YD��E�"�gL.q#�Cbћ�t�DiY��e��e�H�ei$��Ԩ�ue{��"R3��{�d1�����%�D�l/>	��YDd�'�1A���+��6�p��R��MZ�0�hLN;&�g!Rd6.�E	s��v��5���"{��cH�CʐB$�"�0d�%z�A���R�"_O�P��,!O�`��Y�(�o52��g�r7 ���� 0����|o��7�f,K��o�su�z�|Q�Q�?
'� R������T���{鴹X@j^�U�ۅ� }��ɳٓ�(]�3���o�"���B{@���9��O{��c�0��F^��� G�-��F���8��op�e�{�ՍaG�Z����#z˱�H��Y�N�+w���6�It��P�!�E�Yg�p�U����s��²�cg�p��]h��8o�`��,Q��F���A��Da[��3�n$`�����כO7��Z/�w9A�z�Q�������t�wHH�]e7��0�`	X�9k/����x/�v#A
aX���܅d    �.��1��T����,�~���ޭS_��ݴ��,֥C�5KwO��7��5�2��D0�>Fq��r����%����!֤R:ٻ)-�	�H�	<�W	�Mlyk�u"�ʎ�	.�`���`��U�\�Q��ڭ���:|��-��).�k*���Uv�˱a	��Y���9țH/sf燽%��aA-3�R�p��9�,X)]��@z�3���NH/sf�a��sH�qn���-daX(>_q�,�>u+,e�=�|��R&�D�cn��c][�=C����f{s��1@b��[�F�:˗��o�_.cbH����u��e;�#�"Rӎ�vטV�傔���H&LiHһ�U�؞aH��
0$jHҥŀ��{�ڛH�,�>p(�,,�����)@~ILv>�-�;�w �$��?�����
 �j�i����d;'���4��n����N d���BM�a\�=�?ٛMt#��PvK�ԟ�u� �0Ҏ�0=�*Lbz�S�>�G��@�ILrw�W��O0����o�P��6k�#�f1�టb��!!?���S��v��/�]�8y�K��n{6�����
 �.=�`xo���C� �$VN?����1���{��^ �(X��~yih1�]��s@лNقM_�5��Q![x�W��zLbW��V�ޒ-&��y�]7�f��F�'R̩[����7( 
v��ܯB�	L'Z9���&�}�@v)�yr^�7>��<��vep��$v��ԟ<w�Ę�'o@�~����A�9}qE�r���Ę��W�.s߃lA̓Ko�n$�
j.|��=H@�!	ߍw �$�,bG�S�-f�_f��˄���*�:�<h1�O:ߐ���{aC�P�i�7�-&�NH�k��	n���NI���-&��lO�R�-���58�P�tDAZLb
��Y��7X�`��}��}y�]&�N;�~�iO����Ds��l��A�I�ҩ����"�
Y��/&��;�]����+Gm�D՟4��z���)����6l�Lvy3(4�on�@�-�<4�ψ�@�	LEhDq��wx�gN�7YGԫ�������p �V����IVT�������}��t�>�#=��W�P��w }� ��Q�We7z�z��6�y��@m|��/z�Lvn0_n�̇S�ٖ��y�w@��M�G�:�������.�Ϭ�����G����l�|��V6���G��%�B!�^��lb��������/����w�|���/^�WX�#�W��q��՛��~�{o���������o�Y�7K���3��x���̾�-����J{��5�͈��4M�7/=gތnov:�_z���mo���o�����f'�ҫ��|�����3δS��F�!��Y�����_�������s�������4����Bsvgz^�&�BuK{�����J�U��{Ho 2���|�o�B@������wo��������<[�n�=���t���h�lC��|��_�y�����`�O�3����L���{!��|e�E�x�6�
;��n�
@a�2����L܍>��e6�#���YXf�;2�~4 j:�F��Qdh#������-��P)�[�O,��c�P0hc�;���%�!���,}�#�\2��?a܁<��4� ��;�u+/�!��H�-�F}! ��\-� -�J�k�1M��k�/�[�//��I��Ė�;�E�,vR����3	�/4�+����������?	�5���h@}�Qߎ��z�2�Z`��#��G�
l�� iHH+0�ڱ�}!��xm����P�gԷ�@�=K_��.#;����:;zƎ;���>�U!�;�2 P�4��B�@Ga
(����Lv����Ş^��� ����خN�6���ӤM��ӎY�@n�o��ҕ/Ď�v$��/��o�����5jO/��1�B��j �C�֨=��b��!�Xf�#�g�)-�v����`�'2����E���O;*�c�
dYk�l�e�l�dYkA��َ�3��dYk�uZ͗~3�e�5��f;�W}/&nL8gF��|*6��!�Tbb���1o���َbI�
E@�m�6�������cf���Sw�C��r�k����C>ԽBv����{�NG,��L�ė���G����� X��vֻ�A���:�m�(����/d��@a�L�}^ =��ѓ6�/�B t�L��B�����~�� ����8$��z���:/Sj������Kg� �b�:Վ�Vt���S,[��r����q�z(� |�&[s�Y��O��k׿^f=<�.+�>���fV ݡ�}!,���c�>ά@�2g_�c�Hwǈ��p3�è�I&O�GO������r{����l8����w *�o�|��ś�z��{Лxxn8o*��s���F��ɮ�ￊB0���\k�� �X�C�����#g�����o0�ν{�"1Вכ��v����1ǜ�լ��ϫ�Ty�'�]�/|�6ܔ��5wl��D�q���xz|���ɶ*��q,�]c�#�[־t�	��cao�������v��p?Z�v���ǌ��o�6�v��`̛_��a�
@s��/¡r,���o�#@��N ��r̛!s�����Ǽg�d؜`���13��!�3�r���7�p�3c9��W>��̼��>>���05�y_b��9f�W/�$��š�v��Ƽ�Mf<��4����]�?���/,MY�q�M����J���뉥�u�\�6Z'E8�������FBf5�r_��0'do��mc"��'jo�v�Y7��Iy��v� �F���d��vTt��2�d��n;��@�l&���y��fr�$��_��Y%��'j�׽�3¡{"�w�&��d���<�@�=.˘G�1��K�8ꅛ�Ehr��";T��� |f��8�G>3�j�� �t�4>���D
�D�6bl�Q���\�dکIy�S��p7�v;�a̛A�e�na����7��/k	iw���7�#6g/�D0�8!�,�tޡ��2Ay[�~:КFP�O���~4�E�5>�Բ#hb�aN��~4؛���t��?�<u�R��M�Q~l����.E?pTۋ��;�S�hPqs�vD�~4����<�v�\?pI˂N�;V����tQi�%�qɈ=����bͻ�����b�J�$����qɎ����.��KF����&�6�J�Kl;��G��4.yM�%��� ��Vy�0�u��El�ݬ���;�T����ة�n�tӜ�c�n3����o��7��5���~��������]�O6'1b��:���/����a�����Eh�
K�_��i�&������K��`(,t���+B��PX��QŅ�R��>��p��	sN��.�B_�hX���ӫ�����%�;D�!:
F��t����:
F�8u�aj?$�����J?$��q߈?���������qԈd;���΀N�1#�Df%6�������mh�
�K�Bǿ��,����/�F������W�G��]㸇���W�_�ͣ�p=B����,p����$?2�gY��Ǔ��@n[�:�F��I��8`d��c|�҇P(�gmfO�( �ix����l�D� #JS(�O�F��P�Ϛ�Ј��f04@�P�Ϛ����YB>kC/,HȌ�(��%���bi_�Z��j@d_���.��5ޔ̈sr�ݗ��Q�α<Q~'��i^tm�;��рI]K:s%�\�X�ݑu����e/Ӵ)��߱Ӣa�����;�Ϣ����I~����o�h�gN�2M������A�CA�=�Q��w4�,��zGa�(�3��I�t�Վ퀢SU~�l���X؏|�a@�+�z>�GA|��,r�e�6 w��&!��"Y���y�"��i|��Y��`~�9e������SD#z�����f��'���1�vz]����������.�������W1�    a͋����痿���%
�Dn/��^�&�_^�Z��hc_��%J{���KXx���(����Hm&Ί6��0�Kdŗ����W|��_�3LŗH0�E��K c��N�%�1O$=�Ș�-��K c2�<�-�G�d6Q_��DV\`L��K<(�0�eI�Yq&�1�̈́U�	dL�Vq&�1�'ŗ �4�;��a`L�l��f" c�=�X�^ӰP��c`L�һ�h��1-�/�iX>�_��rRtQ`L���Aq&�"�_�T�49�ع�I��Ct�����3���uw��凗�^�����O.?�/���
k� ���]8�_���`��7��8 �q�j7��j��<Ky+#����ٜXH�E k7F捆4X�`u�u#��))f kk6�Ai�~�L�4����i��f	���,�����̟ەI���Ƅ�p��4��F`���,��ٚ��F`���,�	ĵ��k��A\c�~�gy�4�����9?�0��?T��`��H�ں�zG�H����a�C�%?�ݣ4���"��4�����g'�H�ɭH$>{�Ԑ��E$�4��LF)Øh���H��f�J[D1��l�J�SA�h��4��H���f{^��왆$m{8"�ًҶW����kfA�<����OAհr�1�]Hk���*�qn-Znh�CжƖ��M���I@�ߍ���l"g��tx�~�`���AQ�p���udGq���9�f������:�k��\>������^���O�!�_K!�,�ćJa��5T��L*��P㘡":� �ס��"=��L�|ʲ�D���M���y\x���l"��6bd�1��5K��8���l�/ ��Jha�_	��0��lP�Y�s:ݒ�-��md���ALj#�g��&)gyk���s���;�Wn�ls_޿���T��s��Զ�f MpRi���pRi�dGLc9|���k�,e�6)��8�;���B��)���a �p0SV���R�j*RHHqE���ò ���9 �mg^�s�c���d����鄵�k��4X;�o���b�w�__��|�l X�`����+l��s��K�x]Ѿ�j�_��g���"�տsђ��á�߅�˙~�,�|c�-�±VN�e�(ub�e�]���s��ӹb�u
��c��U����m쵳�00j`;V���m`~ �0����# �o`y�Ȁ7(6��#K �����Ȁ?(7�kb�Ӏ�y ��8�G�md���Ԙ�r���FR��+���2�d�<<�G�l�v�G︀>���@����r�������π��9�} {l�4���8t�-M���l����o�!���Ԕ���`OSR������b��)��.�/e�����&Xd`��{a��}j�8�d�Yyc�䣥UOr���Z:�`�$\7���Hp���d�B�ʋCa�Qm��3s��H�k��g���f0�<�օzS�~(L<ܚ�^��¼�7�^����vH>�_�I�Bѻ�n�F;I�kn������ѪHsG�=Pt�����IǺ��q��V؎��"8����_0�<��&!��u��)3s������5����4���Q� �8�[�9��F`����� `���`�4�< ,X3���J,�m#{����
�5��7��`ĵ��}#�ƌښ�󳾑��f e����� i��e`�$�������ABc��ϩ���AB3�<�@�AB�4©�ABc��/�t�`��� �.� ,H
� �O"u�1Ȭ��=�saĚy �l]�� Kl�� ��F�e0�iD\�q0�iD|12`j��Q����fG�S0�cٕ<�Bm�N�iA1� �1��b�� �-�����b ie�|�Ox�i��|��A�i�e�4��A�iY>�� � ���|�g�u��ge��2KRL#!��i<� �1ȬtkQ3=� �˚_����8Sv��n��m��P��[�T(p$g�H�Osm�i�C���@�����Z��OR�`���h�qt�X�aYy�XnŲ;�hj�Y�d�ԥ,r��703 W,5��z�T�N���(�].����!?��h�˭���%s0�u�y�r�[��|C�KZ�̿?��rn�|���E��1-[*!��v���05�)�Դ�b��bQ]����n-f�P�EOs/�&4��Ó$��0ٴ�L�9� �VL��� ̃$L�L H�dXb�9I��4�,Mr��Εm��4I�S�ͯҼ����J:�?��)/���)�^q��M`��A�J�O���eV9�cE�U��垲8V����.�:A���3�����+��$��4V0�n��Ξ������NN��sH�'q,pf���(��<Id������n��W��˯/�\|��S;x��g4pgb.�d'Kt[ȷ�����1�O�����^~~���5̛o���]M��Ӽ|��딮��۫\>�����Ǐ��	�:�黎��>��{]l3����"8y]�u`SJ-;�N^7�+����[V��ƅN�&�NI|\���H�Ng;�X�Y�,��Z�\����9���V�05y������P�A��0T2�?�A���k+om@�5.�}��o���w߂%�m���ŗ;�$Y��M�N��[JƵb=���;�^���?m\�YIu��K`��1񥋀բ[��c:��a�y�v��ae��mX~�EnZ�r������8t���8k��r����܌7N�xퟝ?�ӯ�xɲ���_R��R�������"G�iE+CР�X��[Uj�׭:QC��R_�x-I����Bni'ES:S�������yj;@�x:nd0>�]�z������	�
�s��(W2�È���]PKLhPIڛ�,��i'�oƒ�!�mq�8�u�M�2$Ri�y�8��`��Z��rۮ�wJn�3Υt�>�mvE����c\]&�����mX��k�{�$
���uﰘ��7?��*������ז�+���teek�
N3�S1�8�ڶg {�q��L��
���fg�$:����F����=�]`���A�=��.��j�����;�
@�� }�����0E�I���tc��-�S�^��ʭ1�O�4�,�����*�h�T�lFa���-{1�(��ѰMaɮw
��pz{
��c}���go�{�śo����g,�V�c����	;��#M���z�������]V>L�l��K���}��]>����{g�`�+��8�t:���ک����s:z+oc}�_�,������&Fv��4TF)���ۨ�ڀ���ַ���y����7��_��|V����Y_]~V���7�כ��������[����9j�v�#���kW��w8�f���os���;^m�jN9��^�����_��'1�p���Fs�4}��>��ڮo�̏=�cE�����5���mI:è�&tᣮ��=���Qg�	�k]4�-L�Մv0�	�ٰ}�Ni��x8�����ż6 ŻF�vcmdI6V���,/�� +�y�)�ű2`����V�0kQ�Hb9X԰�b�(��fNzd\��G�q]i�L�tJ�UJ��Ԛd/�
i�o�]\����"q�'��S2OҤ�H�o9�}�"�̹�}�g�Hbs�/�l��apy�l������0�9�@$��C&i��@$>�@����^,���C	��Q������xH?�oH'q��~װ����F���Q<������G����jg����Q�1�h~�躃Y/V�䣕���6������u��ջ��æ��k��7�	b�m����L~k�<��"�۴��VR�|��rN����"��1��X���\��z4��\`u�ؐ�mI�?fi���r�@�rv��-���`��-���`��Y�㟎Ҕ�����Et`Ak�`�m��O�Q%b6ߢ�O}��v2@L氏���#W�L�g^�̩;)����=����_U>���    �W�_��v��_^>�4���,��o�t�N��D�Ǥ]� ����&<��K���_R���{���������.p�,l�sn�A�7�]��vDB֪�N7#9Z�tյ���%�O�r�������|Ұ����_j���=qj���'x���'V.�O�����	���h�Q���?�$�����X��=V���h��>CO��>��gH�g
�Lχ�6��٧ߜ�����N���;:	6+�z	�uI�D6�J����$�m4��+|��x���G5�|r��.����3<�H?�ە3Ϸ��A<���{�b�|o�.x�w|>�L�)���{�$�O|��NB|���ǋ)��OO.vϏ@Sٔ}��tp�+M/�����z"��Hx!�g8M�<n�#�	�5a�"��>CϏ�-`�D� ��4]��O�GB��x�M����E��Gq���1>c�gz�z��3=���D���F`��g�S>j�wD��`��w�8#����;,|�����|��'
D.�`e$���;
����+�>�6�����}����O��3[O��g�X�qF ���39��>㒀�x�x���g\��q�'x��z�$����|&��d���(����;
Xx@��5�L�� >�|&��$�	�3I�g�L�>#��E�"�2k ��g��<F�"�=|�H��L��>S�'b�`�>S$�>�1��pO�8S|&a��>�|&��d�I��I�5��@tM�3=�
�O��+>�V�vV~�̌@)��x6˰��9?�|"��`�>�:��x6��3A��3N��2� $�|���l��L�����gzN�6�q���l��3)*��Z�}���g��ʀ�D�����Ĩ17{�Z[>��=�`�y>�X>$�>���A�y>�Y>��f�`�y��X>��3t .<�g,� \�B�Xk��(`�7��}�����X?���'zxb�l>1��_��7��i��?1�����Up�T��X���?c��3J]{��_�{��g�ւ�����P�Z>#���|�g���D�����3�8k�gt{ց��d��O��9��|"�LOUa��3='��O���l>|�����D���­����_[�>#�ר�����`k=���d �OD��)<���-: ߓ�l��3=Y���g$�t ^"k���\�5� |��V&@�P+� >ӣ-�|"������{�8#�L�r3��h6@�Ps� qF@�n���>�F����6����m���`#���>�F����6��X��8S݅��83E5�bo��R��e�?x��Nw���#�β�`�&�dAh Ӝ�ۜ���lu%��F�=ϊ��,h $@ ��)�����Y����!D�!8��$�aN �Lx�� ��<w�I��+/e4Q���,o��  G��f���s鹀U�5uf$���3@=Q<":S��ʙ���e���^[�������a  ޻�` l,���s�X� �~�a#X�`���ǽ�a�q�]̞�ܬ*�"������?2\��9xo��As���Iޓ�j$�f��.I<�8tI�y�s@�$��4_�O\c׼i�=���P���_�}��t������m����܅�y���f��:>A�}=�R�yn���r�a��s��ܺe����ܷ#>��s���F�71{�ϵbϽ����%�y�����z��z��~{�zn��ʽo����Y����C��ŋ���-����o3b�,�R�y�?���<���-��C��fĬ7at��]�nrυ��Ţqob�8��9��$��y1;ːMھ�}W�
�����͊qN�zc�V#=�� �I�� @��N��ʭf��eŀ���o���{_�xI�;xa��1ωqg����b�;�`�1��gV[υ����b��⇩s ��t�q��߭炿����\�7��;[�����XA��;{���� �����M,��:`�������Hl=������s�߬�O}�8����Y1~ �����b|�7�r� #g��oIl~-��o�[���&ƿ��Ƚ/��ܺY�����[��5��x��\�ob��b�R�'m?�I�͋�c�7#�g㛘�:�'}[��q2��\��ZR�s1������[v�d�[7�oYl<�[[7�-�ٙ�b��q�&/<���K<����[��7���z�����%�������'IO��o ��n��k^"fw�1�E�I�[7�,�?��$��*N���a|�T��8��z.���ŷ��Կ%����:]��C��?~�s<��J<�t2d�QQ��v��������_^~w������7����W��^������7ߛ~����ͷ���姯)V���]�ۿ�?��ULx�u���痿���ǥv��_�}�NX��S�\� �A6rX�6��a�l��dU�/`�45K�uj��Msj�θ�w\���ս#0��X> K�f5@��ۏUW����l���\�_�;g{-�N���Th�h��4l��C�2а���N�=|��|��y.���<��:���0}��n�J�>h���G��yM�#����57v���C|�5%_7G�GSM�&�q�-M��O^���z���?_~�?����@�&eh ��@��pЧa�	L�0��yhP�@�Q�^�x�h�`���aa`��=a�K��+{�� ��aǺ疃�̧��L�`�/��0��0���	�� ��	Ad�ʠ?<�����P�4iu+\����f��{��Ѿg����JPkt9��R*Ν�}�-߅Sy�_1�����p��\�[8t}Фv��@S�6q5�_'.� 7q�L�g���c�x�k�G���x�Y��y[��-��ٵ@,;p�~�P��+�l�ĉ���$q�lb8Ft�2�D�#�<��av�� !XƤ�1I��5s�E�c�L}oV�	GI{�J��>������᫁��캕�z~����y�<Էe �ɏ<H� ���A"�I� ˁ�<H��4]@�k $�!0�����8�u��ʥ�%�w����p�U�������7�$H_��5|�}�߳�'Sc�	�݇n_��Oc���b�0,�4p��L�՜E�c��������/&�t�F�)�Y�2םP�"��㟾��o������Wxo�+tԿBM|�|f��\ ��!���m�1��sd�1[@����I�rVD`ۊ��"�9*"��&2r��m#�)ڶ��mZ��aE8�j�8�4�F��Ò"2r�&r�d�I�5d�"�+2�?�'����"r䨇 Edd��l�)";@����I9p�%J*!�F��#��V���o��~���j������8Wz2�s	?� �6%| N4����3%K�+���P��]`�8rV��q0k����8�cG'��Y2�0F�G�$��81>>�'��9)������c��,�&E�d �kB@;Mh�Y�tф� �4�@GM�@�>ojЉ�z�j��fA���k�Y��G���M����.\����|�Ҩ�Q��T��� �+�z@J�P�jԤ�� 5+�f���j��ǚ�j10V%�(�MQ�%
pSTb���X� 7E%�(�MQ�%
pSTb��4���@���Z,ܔt�Z7��M:��\�P-��pS4Pux8�:1'� �:Q=��:�M���W̛tx8�&�u%�&��	�I�)+q7e%n"țH��	�I'o�y�U�&n*J,A�ME��sS1J3l������*���=i��tNk��MN)o���sJ��79-ρ=�Ub	{:�Ĉ�&��9j�V)�q�MN)�;�&��79�&�n�J�䀛�79�&��:k��Y�>�u��N�.�|6AdAeD�< ��H#  �a�?iA�x=ЂQ
mh��¸��TT"#))_`�J�RR
�R    R�b�N)�� ))�p�R��#�vJ˚���7�N��v* 7-���Q�t��(YSn2J����7E�&��M��+qSDnR�׈�%n��MN)G��MZ3y�V!"A:(yN�#2�����L� ���L� ���^� ���L� ���^� �`O�UNpD�UN�MZ�J�dg��DFnR�a�dg��9�dg��0H��VA$�9*qH�sP�&�d�e��MA�_���R.���� ��J��X����$�Y���UIv֪J�$;k�2@����� ��Z�1�dg��tBI�RU:�$[�*�P��T�N(�V�*$�d+�%J��NޔP��t:�P��T�N(�V�J'�dg��tBI�RU:�$[�*�P��T�N(�V�J'�z�7�$[�*��&��Z�Wb	�d-ρs:��dIvP�I&�d+�$J���%�J�	%�Z��s:�Ĉ(��J���l�zSBI�W��P��f%�^��P�핸	%�^��@�����'�dg�k��a-\�_'Iv���j��Ph��8�I�݈���R�=����xح)5�IvkZ���nMk��:j�
���A��M��֊נ��Z��Z��Y�OB�wP�aP|g��.)`F����MJM�(��Rö��Ԝ.��;'%n�wVj:�@�,&P|g�v')bޤT�@ŷ��&��[IW�@������bm�%���|k������Wc�2�X b��Ք@�X�D 1b'�,@�����������o
Y��<�VzJ��4d�2���N Fxw6 1»3��� Fxwv 1»��F�1v���ޝFxw��=dܻ}bQ��bH�.��v�(
x���ێ���mGXT�6#��0�9m� 1"�C�2s�F1 �e�LԤ��ݓ��C��I��!x�$X�,jRb2�<��'�)��ݓv�C1Z��y@N;��9��&5b�ۍp=���GA��CF�ۏ ��܏ ��܍ J 1�@��n���׳�����q�r[�n7»-z��� �v#�ۂw��m�f>d�������v�w[��6�S�	1�/d�yD�s���~���ݐ� �#�a�|�r�w�!� �#B(ׯi�B@�#���{��y��#\�Ů���aDH򘙏�(�;�I�ۏp=��@�w�!k�Fxw �#�;�w������������="�����c��Q�w�������O�GpT5ː�c5ː�c5ː�c5ː]R5ː]h��]h��]j�Ff2jՆ.�Vm�`&�Vm�)j�Ff2j�Ff2j�Ff2j�Ff2j�Ff2h���LF���L�ZR
�Z��V-�gЪ�"���#-#,*�GZ����DY� C,
[���3���Eu��}�s�3�)�FDP��"�\0aw�h�Z���?����8Bn�A�G��2(���YE["�@E��(��Il1����b��G��
(���YE[q���-�8�.�h�#d5mq�����-���P������8BVS@�G�j
(��YME[qd]@�G�j
(���pE[!�)��=d-��G�j
(��YME[!�)�h�#��P���mqč���8��LE[qc���-��1S@�Gȓ(��#�b�אQ`�m�(@�G�j
(��YME[!�)��#NP���������mq�����-��P@�G�j
(��+mq�����-���P������8BVS@�G�j��}�������n��="�E[��+c��Q��!��I�]Y���1�PQ���XQT	m�g�7��4�D �� �F@$��# 2@��f ���m��2�W!ȸu����s���F~�܁Û�������f��Gpx3��#8���pW	I�U�Ԩ�J0�y�t�+P�%��]>��x¨�\_������+�u��ˏ/�����>����7F�u&SvJ3��*�@U����F����C�jԬ�Z�i�p�ɦ�t����AF���Ǆ��6�Ƥ�N i<`KT ��%�Ƚ2d-aD�a�6�l�1�����~r����W�\~x���?]������ظ�{����
RGn���az��Z<LnPB�(�I�Q
�����(����D���Q�&gl���y0*ВQ�dTT�QI��1�MF��T6T��&��M��&��M��&��M��&��M��&��M�䔸��֫�M�������P���#�&kTrĊ
��P���p�W�an�J<l���[�&�����+�n"%ϱ�MJ�h!o
J1�7Y�n"%n��M��M�����7�79�&R�&�{:%nr�MJ�ꐛ�P97�V�"�*��K���.�K@Ub	o U�%<�Kx�J��� _k�ƪ����MQ)[��MZ�+ܤ����MZ�+ܤ��
�MZ�� ܤ��
�MZ�Dp����I�))�M�)k�7%%F�MI�pSRb�ܔ�tϔ�17%%F��MI�#p����"7)ek�)j�7E%n��MQ��@|MQ��@|MQ��pST����)7E%nJ�MZ��	�I)[Q6��**��D٤U�N�MZU�ܤU���MZU�ܤU���MZJ�ܤ����MZgW�I�I�t07�(>+*p���әܤ��I8i)>p���tᤥo]8i)>Q�U�]8i�4
r�#�t�ד-nRR���II�J�'%u+�.��ԭ�pRR���=���II�J�I�s���#��s:-T�&�4à'��M�'��M�'��M�'��M�'��M�'��M�'��#!7i�Bޤ���.|AU���M~EU⦛.�����7]�U''�&�YhP�tN7�=�����eM	P�<�I�%���T�䀛�T��87�,�7)UC�!7)��nRRh�nRRA�nRRA�nRRA�nRRA�nRRA�nRRA���III�III�W:k&Ϲ)(�"��҈<�MZ�{:��4�.�(�?���.�(�?���.�(Y�V�u�E�_��)E:ԅ%FD]x�ZWব�M��J��ޤ䯨�J�!o��%P�t��P�ӆ���u��:B]�N^G�tJ
2���SR�Q�=��2�p��
��������ԭ�ͺ�����ޤUуf�Am��MZ��ME�%p��=J�MJ�8(7)��ܤt��2p��-y��MZ5�̹)+uy��p�jH�z�V5$#7)1bnҪ�d�&�jH1锬� 7iUC
r��X����!�&�jH���h�0p�V5� 7iekw�p%n���ͩ>����>YP;���<�_]>����ū�������W����{�;�mm�5����}S�W7�	�V���/�ܺ��_V��&{���yu���������wo����~��;�.���;���/����/�~�.��_�ś���;�;Z����1K��y��L���X� ����5Pu�k
�*�+a���/XB5��5�T�|��T�|���+�:-AuGI�j	�I'_�ܤ�L���J'EU�JI,����mS�*l��/T��(q�����YTa+���&�>cU�J}�,�����YTa+����NJy�����YPa'��:U�J}�,���:/Z�j"-k¼I��f��� �:����FI_i�;�Q�X_PRbX��m�r	��m�r	JG�\�s�\U�Z�t�6J5`*l��Kx�&-T�&�\T�F+� ���%@�m�N�,�������6ZTa+i],������ީ����IIubr��Cwn��C
�(��lDnR�9��6J�,���R*l����F��#Bw��;x:��7i�+p�R�pO�d�Н�(���؝[I�g�;�ъ�	�II�g�;�QR�YPa%�����FI�g�;�Ѫ#Bwn����Н�(��l�z�R.ݹ��F�f�&%F̘7)���.�g�*��MiQ���~�vA�+FE}�����to��z� ����Hl�*�8F�K."�QF�CƱh��~��1���qC�j�A_Ǒ��0����1<Èv�s;�?J�C0���2�K
��k�    q��)�Xsg���%f�c�0c0����r��8Fp�3��f�:��<Z��4���~n��&����������qC�A�ϓbW����1s�<�A�~���.q?K'|q�箌��~�Ø��~���~���a�����r?i��5�-�s�����U	/��|КGX�1s��<�38��1��r?7C��΁���r�ϯ��1,��nw��qH��<�C|���|��:�s;f����5��� ��}L.깟�1y�?wC��u��繟�1y��~�i�����w���۝��1$~�Cr�����k>�ۃn���a�\��y�Lz�T��=�5���S0{�ҧ`n�S��!n�n��b�2���7>"�o�t����տkh�����Ts�C����,�}|d�������}�~|f�/A|r
|�^�E�x}|�׹_���dlvQ2ސ�&�d��� �+"{@����"r䤈� �("g�gM�.��h�	9LѶp�W���m;�yE�N�a������ü&2p�ל�þN&��Ƣ-�D� ���n�����R�E�x�	syo̢w����!��2
�L� &��� G��	�`b��K�`�ƍ��,�0(0�Q�V��� �Q�Y��((�e��`�2�J��iG����(��9l4�v��@.`��7`��70�L�0���0���0��7�fP��M���A�z��� �X��bp�X���( `7�X��b�C���7�;�a�;��ii��k�����ۋ�/���\����M�~��7ȯ�N�E)y��VMb�pC�2��9����,b�� ��7J\$�+���.���(";@�����"r C��9��jr��u���N����aŠ��]�a-�%d ��o�2�|A9�?k�vlT]��rJj\�2
&s�lF� %EB��qD�6���Q0����FX����0~�U�0��a���f���0`F����0"U�-m&���}������s���f�
�� ��Vo0KB2� Ə�� 3jm�~�+���҆�@ K+�`"�qaL��q[0e� ���
#F����DV�G� #���0n4���D��U���xn��r��o|d�ӸI�ʐ�"r 䬈�("'�<yL9�UD.����'�*[砈L0fRD�0f�������a�����4�8�4m9L1V%�0ň���#F��##�)2I#Ŝ$�v&G�����C�=G^"�r d��a��"r䬈�9)"@�z�ŀ�i"��+"[�l�� �YEd�0E�.�aK���F�LR��#F#��#=�9L�I�/sd��$�0ҋ�a�#��<�K	�cͰ܋�d��㞰H�W�8" D�H �F@d��# 
@� �Er�B�s�����9y�-�}��3.��4�::��@=��� �:�����M0Ҩ�9hPZ��AW����o�^ǐ,0�י^�t��#�5F
V)8P`��t@���Nh��HIiz����:`���HIgM0R�a$�du�#YFr�HV�e0��I�0�U�^`$�D�HV��=0��a$�dur$��t�c�����HE�<0RVZS`��d��HYiM���#y`��ý)�D� ��u\& #e��!`I'G
7F�`P`$���HJk��6r�HE�O���#E`��3���XoF*:�4#��!�i���(2��F`$��H��~F�:���t�4#E�5M�HAgz�ڔF
�uh0��-��`³6LX�Vr<kS2$`���0R�IW22�Nb����#e�l넶�䔦��CF�:䐁���f`$�e20��a����:�T���9`$�B�"���r=$.4�Yg�PG�Gu��P=�Z%� �A	5*)�&����[�c�J���u9���􊚔P�ϰ���%T�&��"7iYr��7%��&�#Fܔt"]4�M:1'��P�a"�N	�&-n"�&%�!�M)i��)�dk�87e�5Ð79-�c�ZW�&���&��-p���L����*��u������R|�b�ֺ"7)e0�Ik���H��,p)q�n"%nr�M�d������7�79�&R��DJy�n"%nr�MVk��M^�tJ��ޤ4V�{:%k�XoR��=p�W�t��+E:��"�n�J��7y�H灛��� 7y%n
�MN��p�W�� �䕸) 79%n
�MN��p�S� �䔸)��N��r�R87E�\"7y��F8����#�µj�j�Z��tZ��p�
A�s:�
A�s:�
A�s:�
An2JL�s:�
AnҪ�&�&R��d��)7%nJ�MF��p�Q��d��)7%nJ�7)�kFn�Bn��5g�&��dn��If�&��dn��If�&��dn��If�&��dn��I�&��ׂܤ���.\�du�Z:ԅk�`P���A]��t�QK��p��M��J:���I����ܤ��%�y��5%ԅ'�I�OZcE����;]���.\���N���!	u�Fi���J�	u�Y'oJ�W:WO��J���p%�D]xT҆$ЅG%�Q]xT��$�z��[�����Ik��MEɆA��*pSQb	�T�t�(�?��cQ�LA���7%]x,Jy�£�m�䐛�����Y�)k�0pSV�&ЅǬ�M��Y��@�7�.<f%n]x�J���Һz�&�|t�A�9�.<h��J��	t�AI�@�4z	t�A���𠤃I�J:���[K�J:���L�J:���U�]xPR&Ѕ�S���&%n]xЪ�.<()��F/�.<h���.<h�I�.<(�4��n-�.<(�4��J#�.<(�4��J#�.<(i��§�%�7iU/A�4�	t�AI˕@��r	t�A�.RJ��S⦄{:%n]xP���@�d	t�A�wk��MJ�
��ԩ0�.<(uyK�J� �R������3�.<(�3M�Z�5Ѕ���	t�AK���/<�.<(�O�J���R����)��B��0����
ܤ�W:�.<(�fЅ%�F6�7i��II�����D]xPR.dЅ%�B]xPR.dЅ%|]xPR.dЅ�s���\ȠJ����oʠJ�5�锸�pO��M�Jw�2���*c�p-k�~�Ju���µ"�׊t�/\˚�_�V���[N+�~�Z���ke��/\+�a�p����kE:���_�V��~�J��������k�8�_��iC�~�ZY8�WRUe������/\Ii�=֛�rDЅ��7��+)>3�WR�g������/\�ʅ�����y禢����/\I�_��i~�~�J�82�WRUe��u� ��u� ��FϨW�T�A��dԅ+�ϨW�/�Q��K#�.\�oHF]�Rר��p�Nu�J�[3���dԅ+��ɨWꢚA��tk9aޤ���W��Q��16�.\�clF]�R�،�p��gt�YI˕A��4?�W�|�A��t�u�J]�r�Z���.<+��3�³��7�.<+)>3�³��7�.<(���5�.\�spO��M�J�����I��Q������\����ˏ'���ړS��{�n�}�՛o_>����y��lB�\T�N�@^�t/�/Zgˠ/Z��/Jz�:�t�^@^��ܺ���  �t�EI#PrO46�-�Qڣ�y�L��λ(��:�(��.JYu�wQ�{�y%O�wQ�{�y%�P!�&��r�y/1�~�"Ż�\�Ļ7]�5�����{�N�wQ���ܣd���.J��r�q/�q�#e=7���r>*�`,e
p����J�4%J�R eP�{�U/(�%�B0�Al�`t,���O�P���w�b(���]��P���;@�����w�C߷��}�X<��}�V|��K�
�?��߿�(���?("{��Q���?("{��{��
�    �}^-��� �B	����%��ߟU��`���7��u�8j�0���7�u,��%�(KN�2��A�����t�I���ܤU�]nҪ��.7)�8��&�ǲ�r�j��Xy��iyΪ�]ƪe�	P�j`�.wAU���t�W��?&�S�5�b(�G��%ܣ��1ܣ�Sr�[���(�?*��-J];
�h�R��:ڢԍ�$ԇ(�X���(�-��-J�BJ�<Gɚ@G[�z���ܤ�]e�&��t�E��imQ�i[@G[�n���ԅ�h�(�/��i�0C��9��c*�O.�^~����/�p���?^���|�%j&���� �����J��
j���@���"�T���Z��G�J@
j�� �*]�-(�չ :A�J�2���p��<�й�ZQ���fDm:M*p�΅�
ܤsy�B7�\<�P�M:WE*p���.oPp��`��^��b}�����4���� a��P������?>�������q�/˖*6dK:W�*ꭼ�����)_�������b=x84�o&��U84��`�J۵���Y�RĹ�q)�ۛ-���B�m�f��:w��(���$J����qT�ouVT�:�t���P�����5��!N�t��T�4�K�J�|c�赜t����u� **��u�;**����TT�J���N������R��A���}���6I��sE�~�J����ηn+*p��9VE��ηn+*��t�u[Q�EJ����[�:�P����xE�i�0l�H�����H1z-O7�uP���<'`ޤ5Ð7�t���7i���MZ, o�b	赜�X5�j,�n-�@M��Wg+*p�V���n��qTT�&%�^�IGMVQ��t�QQQ��t�!�I����V�0T�~�7%�7)qS�=�7A�夣����M:*���ܤ���x�шWT��iŜ�ܤ5ð��:_I�KGkǁq-jĵN:@#^�NuP#�u�����ij�u��VQ�����P��tߑr*p��>5���'F����ֵ`S�Fi��~��:7++*p�N׸�
�d��	��:�+*p��M�
ܤs/����:�u%��;��:�T����0TP9)�8��J�&B��Ҏ�P*�To"��+�6Jŕ�M�Rq�z���J�&"ț��MD��T�7!7�d0D��TR��S��D
L%�(0�)D��Ԋ��M��8{7+� ��N��P���$T�+� 	��J*HBu�VnQC�5��MZ3|���#���}if�j[�da����]~r�a��|��Ko���z�u�O�����!7�=����!m�<����!-�<����!�<9�	7����FЋY� � (CZ5zZA/(CA{B��'<�����uq�3��!1Z��K�2�.bx��֖�dK<�de<�q��N����b�uvc ��Y����BF���@\�t>��	��I�e�<
�Rـ4�u'��� Y�O7%��G�^*�ݫﵮb(�>~� �^}�QC�����k1�^}�Lb(��;b(��~�)�rS2_Qm!n��+ʠ-Dč� ��Q�Ś��Ř��T� c�eԺ$@���c�VUQ`/2��[�)�|E��`���	}P�O��c��RQ@���ъ
y��]`����%���WIJ��MJ
P���IIJ��MJ
PeoRR�vVR�({���@ٛ�4@��MJ
Peo��rEnRR�({�R�0eoRR�RnRR�({���@ٛ���ޤ� %P�&%(��7�|���bޤT�,x�\��
�$Wʛ
�M:3lAٛ��Z�t�?���Po*p�}�{*��tт�7�<CżI����i-�/�0��&��^�1
���t�5K�MJwD-�N��a��MJ� ��x��������[nR�܁%�&���pO���M:����7�|���"7)��I�3��<�no-r���p.��G��d��O��M0�gU���f�}�a����RM쀅6��<�X�g�� ����=�`�u����=��{`���`����z���X`��r�8X`����0Xh�L���q��R�U�q��R�%�q��R���`���W��K%���>���q{`9I����`9I���}�`�j ��l�om��%X[� ����}�q�`�t6�7�����
@S)5KF��
@R���q��R�� ��Bhs��b,�R�M>��B*e�X
�@�}��q����b)hM��y��"Ki���
��.�I�B.u��d,l��w[wl��9B;�g^��,u�7X�y=��K=���X`����q��R�kC�X�y}	��B.����{`���`A=��{{`���n�J�K�57����k�",���@X���A�u��p���{�ْ�Jp����ГS��n�����$�f���R������ѳ�83k�P�Z� ������!�?��72�ډ������"��*��7s?f��O���gǯ�������w���� ��k���(���z#�0
�4RU���<�� 9��g�X ���M���\c=X ��ڔ�`�ЮqփB�����v]b�,P�u=�z�x��:�@{�+ׂ�.�%�,E
����u���`��>���-��RW�,������,�q����K}\7�[`��>�=�-��R�/�X��d�[`�
��Rc)�l�9��v@���Ǯρ,�O 1�c�~��K�@��X�� zt���;��'�"ݱD?$�%�,�P�;�3�Jݱ�� *u�J���+��Rw��:�Jݱ�� *u�J���+��Rw��:`,�b)P�;�So �z%}7/�H=�jh�����j�P9�ꎥ�	�Pw,�O ��c)~(�K�@��X����XI&(���%�D��.�P��Ҝ���>�P�Ϊ1�Pg�T��j*�Y5��À
uV�a@�:��%�BݱD�ꙶ��챔7�,�M@�:Ky@�7,�-��hX`�nm�G�K]�iփ�ʬ�/a(E[dd)���
u�3�B�eK�B�eK�B�eK�B�eK�B��e|�c�(���s׃���v�z���$]��@�]�}�7Y )�d�`I2+p����x@��h"�;���&�����x
�R�s$�&�͹��x
&|,չc��	��@u�X5�T�Uc@u�X5�T�Uc@u�X5�T�Uc*&|,���R��<��ܱ�T"����0��\H�o� :�׺��Z���6E��*�r��FP��u���P3X�9v��\�(Z�*GlAm.�w�bs��/WCEnb��+�"��\�;���
�tݛh5T���D���8�3�j��;��)��
U��*��PAc�EJ��z@%�+(���K�j��M�}�VCn"��Fn"}'��\H� .��"h˅�!��r�~_��B�xba�\����
q��E7�l8 7����k��j��Mת��P�����WCn�~v_����}-TД����j��ӑ�	�r��*r)Z�x�D�&��+25y }-F��H��Zr��#h��S����Y�J�@��y!y }�=��<�>MAF�KWC����1�"�p]�*p�u��j��M�O6FP����#���s�������@��`�x }<1�x<�>A;HŌ	�&7�r<\W���
�D�pzLxNB�xN�WP���TT��*��P����WCn��q\���q5T��
��P��X6��D:s2ޅ�<���;�j��M�����7]�R[�麓�j��M׍�VCŜ��M�o��8��ӑ�aP���&j��B�t]h�*hą��q�����
��ے��7������R߀:\X��K}�pa�o�!9I�����
�~I*HE]8)kVЅ)kVԅ��fE]8)kVԅ��fE]8)kVԅ��fE]8)kVԅ��5E]8��U�9I����$���.ܓ�7���(\A�I��؟�t�.ܓ�7
�pOR�(��=I}��qɆQN�Qԅ�n�tឤ�Tn"U�)��=��OA�IU|
�pO��S����M���*>    �M�x8�}��@�I*HE]8���.\H:E]8I��'�`u�$��.���Qԅ�t0��p�FQN��(��I����pR�|E]8I��҇t�B����.\��M�%q�����j��MJ�&Ѕ�u۝�P����
}�����jC� ��Fh�Mȉ$5R�b_R��p!�o��B��(Å$�Q�I~� ��FA.B:�@.$���0\H�M�Ա<��T��	�:7�0\He|
�p!��)ÅTƧ R��0\He|
�p!��iƤ��M�&R�QD�BŸ��j�)���GRCaxd�o@Y��GR�ax$55R�GR'ax$Iy��u���H*Q�G�4��u	��Ⱥpaxd]��0<�.AY�� ��b�G�e8�#K�Q��Hy�#I��@I����H�%�G�s~ax$I��#I.�@I����H�A&�G��39�&*r���#��"�0��sP��H���#�^"�0<�Z�&�9˚��H�W	��T��@I/��#7��
��HzL �����HzEJ �����HzL�Dz	M ��W���@ʚ� 7��W�����$)	���<����^������ɜ@I��	��T��@I��	��T��@IZ���H����D�WP�G�F;�2<���	�ᑤ�O���:���H��H�������H��I�������H�
��Hs%P�G��7�2<��0	��$�I��$�Sax$���#I��@I"���H$&�'�\r)�Î�؄�Y�W �4��$axe=��0<���SB)� ax$�*L�1��a"a�p�
c�p�t!���7a�pR������i`�p7e�&�\�2�fMЕ�6W��H�C
�I]R
�Ia
�I�6v'u�J�1��G5�0\I��v��+rk�7����d� �,	
�Y���+rɆQN��qax ɖ�+ax`� QN��@H�m��T�AH�^��$H� �r���@�쐛X��M�R��P�Ĺ� �r���@*�� �r�쑛8YsFa8���TR�=�t,T�&R����$nax ��3��|${��Hք�pG:�PN��NFa8�:��7�,7�����W��H�H���|��:��t��g���*�Q+�*����&���'k"�
�5�P�j�v$T��Vj��zj��*r�s���4׈�D��ܤ$��MJ:s"p���)7)��#pSfٰ��o�P���t�G�&%E0�&�I����j���K+TTҙ��M�dM��Ě��
��	���V8*�T��,�����5!7����TH֔ n�$�I�J����M	����5ANWH�� nʤh-AܔY,qS&�D��.�"ӌ�M$n�7�\1nb�B�$,k��NXsn�57	���MB:�2p��N��$��� 7	�+7y���&�IW��k���<�_p�'�kn�,n�,n�$k���U�IW!�c݅W�&Gb�
��Xsn�,T��BnR�� 7E�\��"ˆ��"�T/���� n��(�8��9Ջn��S�8��9ՋÜ��9�7E7�9���n
�n
$n��M��M�)���77y�@�&�9��<�M���x��X�7�Pᝎ�M��H�Z��Xњ@NǊ���Yњ�;+Zx�cEk�t�hM@C�b	+F�&R��p�bЅ{V��pϊ�@�Y���=+Z]�gEk���ht���.ܓ^
��=IS[�M���.ܓ4�t�ϕ�T�'�+�����>�B�>R�����}��|w���7?8�z���{�(��H5,t�T�RP'N�*�����:qO�9+������:q��CA�8�6��N���S@'�IUBt�TuPP'N��)
ܤ$E�8����N�T�UP'N��+�'�:ԉ���t�T�]P'Ί�P'N�vԉ�t�t�T%T@'�Iڮ:qO�vЉ{����Nܓ�]t➤�*�g�g�&R,:qOR�Љ{G�&Љ{G�&Љ{G�&Љ{G�&Љ{G�&Љ{G�&ԉ;����%q��}%q��=IZ@'�I�It�T9S
�۱�
�D��)���ʙ�:qR�LA�8�r�T��#1"��=�F�T�'1bŜ��
�D�-s:־7e7�Nܓz�TЉ{R׷
:qO�VA'"��
�qw����"�(�F�PE�h�s�s7WAg�I��t�t7WAgH��t�����<���TЙR�
:�@�CRAgH�Ut��TЙR�WAgH]2�Gnb�7�:3UЙ�kE�y �VTЙ�kE�y �VTЙ�kE�&�-Y�y �VTЙ��m�y �VTЙҫq�y`�à3$�_�y i�*��I�WAgH�
:�@��UЙ�����<�4~t恤���&ҾF�&���Μ��ZAgH�e*���m]y uۭ�+���t�Ի���<�z�VЕR����H���}��@WI�
�rw}�Ǻ����~m���*�g���]�>��`�#�.�]�N�FQ`��(*�"n3
б���L�(0n#�2	��o4w��j���:�����:˧���:맍����6
���[�(�+�o	X� ]���5����(d�Q w^�R�Q w^�bh� ����m��@ʙ3�5�"��ܸQV:~��ܠ�w�յ�Q 7^w��Q7:���]� �F�9�q�E�_��>��'ܬ���͇�:�����}q�-�.̰�I�.����<��W�:�vB��6;����c�C�zݽ�6
�W�{m�F�|�G�6
�����Q@=����Hp�u�F�(���;7�F���F��#m��!�$A}���QA�;p�um�˚�E�>�-�\xݧ���F���M�X_�I�2Ac}�&Q����D-4đ�]h���}3�\�Ss4A!R^ &(���kY+��ږ6
����[�(���qi� m�7�
���*ā���*rE�9��qz4O��_w���4�}�:���NV��#��c�[�jN���(Y�:�{FR� �Òx�9��WfB�o�p�ꠞC85�sT��@=�p�ꠞC8շꠞC8�^uP�!E�:����W�sGѫ�9���U��Q���3��) 7�bȈ9�FwP�!�JuW� �2�wp:����N�uuX�����:���|CL�wp�!��;8�S���o�����7��A}G��n�=�W갾�/9m��]���;���6U�A�t�S�x7O�i���L�{!�x�1���:����EY���IO�[N'=u	����PO�zSIx׾�(��}�����_����m��f��[�K@=E�*v�z���"H�S�����}�6����"p���'�z��z��^�3�K!E�PO��)�B�����:ل
����鄊9*)�.x�F����!p��6�"w�"�q�F�u� �i����A�p7E�0�2A���7ǟL�������(�#|�f��Ꮯ�E9���Q�J(P�J((=���`Q�Τ�Q"��5,쬎�(�`d���`��� �����g���`���������������3	���*�cD���Ǜ1<0����������<����+P�&~�3���Ι��_���O�u�,�4��נ�y��ïAAK�9Q^��쾨����?��*�w�-����U�"�����;&3ņ������<q�_����N<�\�W�qo���-�=61`~i�\��O_FZ�:[�4�������(��䞳�0:��=�5�P�8�;�ëmQ�^N��	U�Q�w���������g�᫅�/M���|a�{?����� ���#^^��	�>|f�#��iXϱ���g�N��l�)�z�M;Xϳi� �y6�`=Ϧ���ٴS��<;�(�z�
�w�i�
/��|�J�P�]�Mo�U�&^�]��*���g�̮N歧��
�h���+*�k���F���F����aMp�z�������E2�1e$�5��Er6���O������z��    )�����C6�y�?$�3��	�v<��t=�}�1ֻ8����Q�������/1�����`?ߖ�U���W�be�׺kX`^uU�
�Zu���V]C�WŚ�����>�w�?ZýO�h.��^��
�� ���3�� �g�W�d����_���ę��z����z���XϳI7 �y6�`=���3���B�����> �y�"F۴җ'4Dg79�<z����]���}����%*��Cژ �}�D`�Ħ�X �}��
�l�S`��v<E�c�* ��{���#G��2�vX/�iG��2;�S`�̦E֣;�^fs~�[�����.ٴ�/i�*X6��n�y�*�bS�u����L{,�%�[Gֵ��.~n�����"������Z>{��0+s��X0�f�`��<�g��`����3O�H�L�)����	<9��CJ�,�C��	<)_��"�n�P�-�P�pB��+�C���x(R��<$�ؤ E
f�x�)��*�C��CJ�
<���C����C��+�C��+�9�~F<���c���9ƙ�c�Jt�C��C�9ƙ�g�+�a<�����CB�!<�)<䁇<��<�����C��	xHqB��C��O�!J�����⟂<D�O�
�P�S��(�"g��8A�br|E�Ŭ�̀ɱ�����I�M�L��o0��ĚA�<�B L������P���x(Qx( %
�!�~qr�h�!_(�=��N��C�<;q�<Dyw�y�rfG�!N���8k<ĹÈ�C�S��8wR
<��Wx�sǨ�C����CNP{?�9q�&8?9����	Z ��hL
�'��(v�<`R�6	`Rb��?)ܗ"`R8>!Q�6q�<T)<zjϹKx?D�g�x����!��d��8��!�p_�x����2�Y���(gv����d�!��qb͂<D9�
�P��詅s7^0��P⼹�!
'���5c�����u�<D�w�x�R�+���!V��(��B<D�w�x�R�+���!V�!��;V�!J�C��C�Z�X��(�ꀇ(u�ꀇcm����OE=uf�:��8k<���x(s�x�R�x(s�y�'�R�y�!�ؐ�xHg�z��8�灇(}�Q�'�G�`Q��	g?��(:c�!��X�C��ű�5UP�ș'�P��C��%�G=u��&��Δ8�ԙ�}�����v=5�ϒ�!&��������HQOM�?������Q�SSz)�)��z�SϾBy�Ԉ<D�ϋ���	L��(5�zjJ�����R㯨���2P�SS��Ԕވ�ݞ���c���B�+Eˣ
u�ݛ*�Ss�Oរ�S�z{��MAOͩ�T�Ss�?�Ԝ�O=5��SQOMѸ(�9y�9�&�9�>E=5�~EQOM�/S�SSjI�Ԕ�2E=5��SQOM�/ӄ<D9��?��ԗiF��-�����2��Ԟ҃C3�'���Ԟ�����bj�^SQOM�9U�O�y���Ԝ7t�O�yC/p?D�q�������Sst؟����Ԕ>.���)}\�SS��(����qQ�OM��؟:Q��OM�M�؟�RӦ؟�����Ԕ�+��Ԕ�H��Ԕ�+��Ԕ�+��Ԕ�3ajJO�䀇(�ۄzj��']�|��?5Eo��?5EW��?5E?��?5E'��?5�V:aj�&?y���H	�S{J�L�p?D�������6AjO������,AjO�o����;���='N��ԞR�y�⟂<D�O�O�)53	�S{J=R�!J�b�!ʝT�!��7	�A�� qr���) Q�tR�����L�!
��!N^0��P ��y�r��!N.��8��<D�[�O͹7�QzE�<D�ߦ<D��Hx�Rב"���#E�!J]G��C�Y[�!��;���R��@O�)5�	�ԞR��y����C���Q��SSz�%�S{ʷ�����AK؟��M��zjJ���zjJ?��zj��'ajJO��zjJ��zjJ���zjJ/��zjJ���zjJoĄzjJ﵄zjJzB=5�ZB=5�g`jz����T[+s��4�?aNK�0{���a�������``36Y�Y+O��0�Ă- K��
���t�6�`=�
V �e�% 9��D�e�cQ�e�mI �"ǂ,�Y��R�fR��Rd�mu �Z�
,Y�X1�b5�"�`#��b)�"ǚ`���Ky�!K�8�B,�I'PvKy��f,�I~��R���A��I'Pv��	)r�X����A��b�쀥����RJ"�쀥�eRX*���1�"����.2�(��R�,���6{d)��zd)���!mo�,��+��-��Y�`�'����?~��W�:�vB����Y�$@K�EK��������u��(��
^D�U�"�f�pUh���u�JX�a��r��`���8x�dV���h��R��RX��X*@�X, xRKL�X,��X1[�6f�/��+c�� 6|�c^��-N�g�G �eW|-N ��}�8��eg{-�����Z��Z.3��e�}-�V��kq�V[7>�/ܯ�>ȫ����@!�]�+D�7��/��]U`�����8[��U����
i�r�thY^��	c��ή\�!�y-pI�N�8[�f�	b���kql��:b�1f��<V���F�e�kq0�Xϝ ��z%Nz��y-�����a=P��.�@���n��)�"P.'��
(��n�ˉv���D{t�ˤ@���u��h��R���ˉ&�r�	A@��hB����,��r�	AP�L��r��d,��Y�˩�s,�Tǵ� X`����A��R���`��:�2�K%�	���q�:X*���␥H_�r+�%�b,Eb���H,Uf|$�*3>KP.KFV@��:v�Z�RV6_@��,�Q�����J�[P.+�oA��4�岲���e�|�\VVPS@���d�x`)V�L!��Jd��U�V@Ȭ���Bfeռ2+롾�Y�u���YY��Bfei�
��%�-��ˤ@Ȭ,io!������JK4AȬ�'�Bfe{��,�:oAȬ�[�0�b���uW�-���R�[���X��X��J�,Y��J� �r�� ˢ�� �E�1,+r��R�>[%b��r �b53+�aoi��R�� ���j�W@���&�E!�buz,
���eᶲ�xE�b�jY*�̈́���&��b	�~��~��&��h+H�#-�OK�N����&�-+�I�R��/;�e9P�X���	]�#�UDɘ�89c��b)О+�c\�y�ݰb��@�-�	m��DX��]��]`�laq2v�'��<ӞA{�i�p�=�E��=ϴ��f�"c�.�.��˒+�Tc�-h�3����v/�� ��癦2�y��.@{�i��=ϴ����~��̺���=Ϭ˿�0�"�m�yfɴ*v�fKV�J��"K����P/E�-�X��DQA{�Yb��1���b,ŲdО'�}r�yb�KUО'��zl�B�[`)� �b�l�}r�yb]�WО'�Ug�yb=�TО'֥}�yb�L*j�Y����s���
�R,qKE�9KVA{����R������v���X���H�R��Fc)�ߢ��v���7[�@�dО'Z��D�dԞ����%���=��"K�Y�u�Ed),�R��6��~)2�ȥ�gc����|���g�ǟN�w~��|7ь�����m�?;~���_O?���o��{7�@�f�ZW�:*��i�)�['���eJ����Y�� &������X�v����s������Ł���^�]i;z5�{X�ն�VhCۑ���v�^�mh;^K_�mh;�_�3%�І�C��Z���[��� ���{�>�x}{-N<qv��hx>������7�^���H���ӯ���߿}����e��;����c"{�����ʻ��?���2�g����s{P�@5���f�+�+X,d�+M���    VB�4$�o7� =t<ݿҝ��l�j�=����d�Xk����ޤ,3��3����Ϳh}6�O$v���/��ɴn?9������#��O��]�l�)/���!��ϼ� ����J
���وe��S&L:V�$@b�Z�$pVJn&�Ղ&I`���a>��A���FRa>��Op0����	�`��	p��ַ/&���>�3� ��I�	�`�O$M8��E�.!:�ů�� a5~��pv�I}%~������8�eth�^������j���y�P���C��J��c�C�kq��Y�s�ģJ���ȋ"�*E#��	W���׮�t*��d~߬c��v�w����},P�@s�͕�
 �8�
KWVj�?P^�PZH H�
 ��յ&H�R0����z@�~Ec f(+�0CYϏ20CYo�20CZ�20��-y% `��3���!�h�y=R��y�=f�+�2�z1CfH�@3���{�)g~H�Y��S�[�y�{o��U\<	 �I�gf7��~�]�@� �$�wVa�ʟo���P�;cqwӼ�k��w+��gh`;(�]`�;���U ���WU�J�@��G�]����I�K��kQ�o"��+�))���_�+�n0���A}���w���!6�:�	��[��Fk|�;��ae�
lXa�VX�ʁ�'��e���ֳ`�.r!Y�?)�}�p��� ���������So�˪Ҧ�'XY�j
lX��d�iciɟ>���Z:}�� ���L�{�e��GZb�� �"a�cY�W�-)���'�%g���`��
mo��
��X���V��
��X��XJ��*��Y��x��,�d)]�T��-�mo�I��o_�gq:����xHk^&�����e+y-�i��D�y9M{-����g��ǿ�ЯŁ�+��"0����ӫvz�E����L���^D�X�J� �j���jl�-�jl�-:"��� [���-�˩�kq𾘕��
�,2T�/f�<��Ŭ�Gm�#���("rEa��K��z�L(��F�j�%��Q�+����ڹ�΁��Y+��j8	��ղ�q�_-Hwtp�kq ���z-�CX-{H�ףڒqe��)YXZ2�0�aE��li�`Y�����A�X�%gX�mV ˺��`Y!YF�b�XJY�v� �"�,�,�ʖ��a� KE�"`�̢�,YtQ��"m��R���,Y_A�b�X�#��,E[d��"�(��R���K)��+���X�K)��*�R��E�b�E�,%<K���7[�RB��Z�D�����[q`I~+N �9� K�dq`I�8���"K��6,)��T&��8��2��<�R��RY�Ԉ�b]���,�x���,@<�R����R��Q<���D<�R,r�K�.�E�����,ź�A�bх@,ź��X�ui/���^X�ui/�,�
�Ϊ��D����R�R-9���gK�� ��۳��u��ϰ,N>�O��D3@+�BԱ��sTS9`�Y� XW��F`�������T����0M"�+���R,K�Xm�J�#V۳���z)Vx��h�y���犱�ob)Zx���Z�K�.�Y�u)���Ic)K)���I��h�O�,Ŋ.���r�D3y�e�m�X�U-	n�Y�$EXdK��ܱ:�hυ�fFR������X��玥s��,�2��,�:oA{�h��=g��,�j�#�=w�ր���Xt�s��=���9ˁ@{.�GrО���R����ЎО;V�1A����6'���笾�R���K2��}E��~7�r�rܗ*n�e[�۞���24zIZ{�/C���\[V+a�B������Pz~~Ř������N�i�Z
����N����\B����y��ow���U2��,���WD
�TVD��3���)=���Rx�_	'��)�aH��3����bۯ�B�ƭ�[H'I�)��<�����H�>��<pb͕��N]4VB8u�[		x@�DV8�eWB�Hkz.pDZ�s8"���܊H�iE���8��6�BZ����G0:7�����E�m������w=��늻��u�9��늞��uE����Y��V�gv V+��8"��-"G�qH�����L�V�����u�m���b��dEƉ�~͝�'�q�4��b^��(F+��q6�~<?�(��|�������Ef�g��o$��o��//A��=}>��-���[ ��`+�flr �X�`Y��`#6 ,ˁRXa�K��&,��o�T��-�T��-���f���
�o�t�HX���N�X`��:o3�Tf�m��4K��,���R�u�f`�L�[`��:o�Tf�E�X*��ۂ,E�-�T��X���<���T�-K���,X_��l1�b|XJX'P��QP���uT`)a�c�9V`)Z�Z�#�okX��b,E[�
�%�EtR/�%G�a�$��N ��R��%�Tt`i{�֤��@�%�dKE���R��%���U�e��G�"������� ,��<�R��Y�e��K�y�ϋ��߉j�A>P	r�F}�
F��
F]cb���}��KS�0�<� �"xw���?�K�URw|{ӕ��J��&���5h�����֗7M�-�p;7��k@@�5 @�5 b����^�tB�!��;�'��,���	 d�~�{����^X�����������6������?~�?߹���q�Ż{�>}��s����~��k����px�a�������N�?���Ds���}ɴWwp�9�Rq��s�o�������������矾��iw���i��׿mI���X����F
�H���?#�t�)���H
HeA�n0�o�����4��L�{G�U����iD�����?M�_N�����ݛ��t�����2Q�O?9���o������b��?9�������㷆�P� ����<��y�C��݆���i��ADJ���̟�3CI�Pv�Գ��9�{�W�>�C���2�J���t����mP�P����y�k�OKuv��(4���z4�~:lG�F=�&,�i�����f���hv[�&�h�2�4�Ď&/kS��	0���F7M���Ѵ\F��)���N��h�>�>��k>��i9}4��n��dv�C�%?Hj��Ѩ�ш�vs>�G��lpN�
�&.�ق�5�ht��ka4Ɍf���v4n�)W�X���G/k��9����2��b4`�S���f��J`�n�b�A�Ia4jF���$��~�n�6����f���pjN��e4[pq�n���Ne�po�-b��M|�E\��ý�od������X�po��i��)0s2<m�6Q8�7�֦`�`�F6X�9�7��Qz.�e��4����9��� ����X�b1'C�bm��Ŝy�� ��|�;\,&��"�+�ݙ�7n�S�X��57X�����7m�a�+�V��S���^n��qq*��:M���<�6��ƻ�|���攡ޅ�v!�Gٵ'�&�r�g��ݽ�O�}M�����F&�3��V�sEw���)`o�	��3�f(���֢�=�j3m�y0��+3�6ve�e0�{��F�_�I
y��1�1�)�p>�WF�5�L>��۱Ӿ���/ʹ!̝�Z���ؚ���:��>;�TI#@�	tn��E9���t�jG �tn�H -fyO�eh�=��t����(��r�w�u����*4�p@ȡp@��H�{&��|�JZ�
��m�*��m���Cj������}��)���-��F!����(��(%Fj_����C�}ÂR�}Âr�?m�*�q�����a$�`yI�H����8.#vy�� hC�2b��{��
�2F
���s��.��Ӏ{ʉ�)gy�?�0R� ���( �1� �#E��r$CR �0R�S��1(��#2iy��#�r�&���.�u��    ��i��W[up���(�հ�a����L��r��-���4tmW�_f���>�玦S]f�;k�1Ƚw���&;�9�`����M�#�����F}�:����b9�3 "r�JD�y�tGB��"g✽d�>�`�����̢�@aq� ��-v�&3�����s���U����#�0���F�6r�L$�Dn�(K �u�X׋რq�]�v[xc��c_��n�31�w!�]�F�A����l`Q`�1�6��a�Q��� F�ɮA��\�F��`�-� 9q_P�D݀"U��"U�� '��DN�[���l(p���'��N�[�pb܀r��� N�N�q�n�	|A7���P7��K�D(|!o`�s�΅��6���Aڀ�2�i�s!C|�682�L0RN���81m��81o0������ļ�/�ļ+�ļ+̙6`傜�A|P����q��X0N� F*��u�5���eK���eN�'n��8�l�H��78+pb�b��X�ĲA�T���X��[�B�9Qr"?k���eV:/��a�] E\���7P��N�@�(8q-�8��4�7�f�N�@&��#@N�G��!N�@!)��T��7���p�Nܠ
D<�7n����D�²�7�Z�o�H��[�ĉ�ĉ��7�^Y6�P+��F����V7l�PA!�  '��ƀq�J N0R��y��9 '�81 '�81 '�81`��� '�| q�v��[�LX��A�`��'�/lP�)X�������Ʉ�[ĉX���Ʉ�[p"�/lq2a���y
��E����[�X����/l��rU��'b���:�/lq������/lq���[�'b��5]��tX����m^N��6/��k����y���sCv'��O[o�!�	Jm����,�
��ۂ�6��E^f�ʂ +,���� Y�ශ��`i��](��|�M@s|B����M(��,�M�R�r�,X'P���&d)��&d)��K��KE��f�R>��6[�� #K���,�i��X�e�X��,XʳN�,�i&,�Y'P���`,�J�
�R�,�X_A���KyK��X,U����RXJX,U0�c�TA��d�~'�o{?�n���KƧ��6��=���&{�n%6[�SPÀ�v�6N�����K�9���쪦r�u�VfA��J���?��_ދ�X�L��ǔ)��w�;�͊<����p�0�oo~�L��5��v~w���׿���ݽ�w?��.<��{7��i���/�6�vm��%;���������}����y���������z���۝�����d}u���S0�2W_>��Q�yr������#�Y&;�)��̲}�2�V�3�R���4K�?�����?�r�W��ց���̰�v�g�g;��!y��B��fP�0%�v�Z��<�|6�p`A`��5� C�ea�Pl59�Lc���M+0_ �]�n7�O�0%;-ZI�L?���X>MӁr��i�#�kKL��4��|��8q��'>��i:&���D	ЏPt��>�̧o~�2���R�͡Q�C#՗�t:4��tẔp��Bg�~�.Ξ��A*���w0� ��r�)�����g�qR���?��?��������60nZ ��͇�~q߸�^㗟~�����?'���NÛP����m���C���%���ݓ�����B{��h��� ��{���~
���y��_�ݟ�{�'XS�~���ٓr�f��t:��dűE���M��/i~k�,�d��!��Uva?����]>��L�'��?��qF1����k��e>�����c���s?sO2{K�"�goɏ��&��m��.���8�nZߞ<> 3KẌ́�l�;!�	e3�:pBSV�"��i��Y�4���u�"�]��4BH����O?[f��S��>C������}�X�k�����9�����=�	mb�ft��]{R[��<��5�v��}�����jf�gv~�:ϬJ�̦��3�HF&�V.h;�Z �tA+�5ТE����ʜF|C�Y����'�;H;��;C�6����ö���5��'�w����o��7?8��͟����㯧�����o~����\���}�{��y �.�Zˮ���u���灨?��g��<�k������\�HEw�K:���Ufݓ�K�2���	��w�/�	��L1��{3G���LI��!�q0������o��Rzޜ�e���)����B��ʼ9�8�*Z�r��Xi_��1V�F(�P�rl�V'Ԍ�2T�PSs�J2*��@���h�P�tI:�TZ��c7��{�CH�*�h$HeA:��HHuA�l�� A��� �ц.�śI�~��3)$�� I���q� QU����(�1�2�(���+���z+ �j����P�2EK�U���탩����HHƩv�� �x�z�����o}H
H��x짤>$�	cz���0z �#�'78�@.-�_Σ��&�4�2���S>B<�����S𮝊O���~��:#�����&�H6B@!�L�#���� �9��}b��B�V=�I}��)$�Y�sR'P���m�UH18��)�.�T>��ޚ�Us$�����*��*�#�N( �h����z*pE4ǯ���=�@���~0�*0E4Af�������~2:JWp_57���ө�5�T$�_Ɇ�F�o�w_��qq>�ݓ���P[]��{�r��n�~f���k�&�zA۵>��h�އ�`Ѧ���j���-Z2h�+�)�邖v+�%ط��E�����$ y~�?<=���VRU�����
�j~$�F!M~��O��Z��?Z�sݵ���ɏ�?:���7~�ݛ����@�q�=�zzY�Y�� ��m�#a���i�yp#af�͢}�y�V� ��f6Ca��I�2���գP5�/�ԫA�[0��F.hG6>�^=�������Wo~p��񟏿;��
��7����y���o��C㋓��Z��8�~��\���񃳹q�
xr��q$x��xg��֕~L¨��=]4���ƍt���Ҋy��h���2�dc�/�/��'�akq���3�����9���?ON��G���J���m�Ʈ3�	��}��e��x���>����sp}�5�����@��HK �z����.��n4�|Pd�-糞��䡽7��"y�,�<^�����7���L����?���O����{�/?_������ ��/'�Ǐ���~���{��V���r���VT��Xա��Uv�i4T�Y��qG��
���j�vN���Y�d��1W���~>Y$!oH ��,��`/��e��0_�6)��y� �H���<|g���0��T�֊t8ЎO��Doi�8s�gO�]c���L�:������Ǯ��{��.iU�g�0�o�6q��S���_�+}� W��Wō��&�S��:#�0��U���)���M0_����f��f�߸�o|�:w�o\1�aU�
����5q�Y\]p��cv�du�s�׼x@]V�><��
QR1QRx\Ӈ"�b���A��!�詘�Ƚ��;q����Ƞ��B�TL���J��z��qS5v�^���v1T1��ӫ8��`c�Uc� )]5~��� ���|�|{�y���o�v�6'�[4y�Y�9���
I�Hs�у �\�B��A'R�B����9=��H
HiAڻ�H	�tAz*��2 ���F*)�}ڇ��W���~�f!�z��iV"��,d]�܂t��s�uY=��Q��>F�Hf���W�+���aA�k-FZp�z�g�>$��`xo#G$����}�Hj�����8"E���{}H�i����٨	8"�A�?s���#�p��(p�ޓ���oN�j�h�?�.�S�dV�i��G����ب	8B�?�~��C�P�參#��&�x    �g�.�H����FB��H��{�?%�o�����͙[�S���$,�s��M�Qgj	8\��8	8��}��>$�gs���r��&w����}H�b���G�]V��#�� �m/G�bVop���#��<	8"-H��o{]��#�9��O�l9��\��ڞ�V~=H�����syߜ�#�pġ�>�˟
pD��9�ۇl��o{}Hxa�X�{8"�=�+��f ��gp���>	��a�s¾}�8B�>��=��zepP�#L�88���b8�qp�V1��Q����
!�#ߺU�1QsyE��o ���"G�}='��j��uΩ�t��e�r�4�~�G�On�=l�(�v����ɔ@9�g��J��eh>�M��ec����YLq@�P{{ՙ?G�a�W"L�{�^cÂ�?v�Dq��p���!N!J_"5����C°n�yXu�8L<��~�,_T�B�k�I�=�
H��2�m��ǲx�a��y��j�3���Cu)���C^X��F~��9}�F��E���>��~�˔����F<�Xޡ?�CB�X�T��+�Pdc�s�q!�Y�A��eE���{��C61�Cg�׻K��g����ױ2����pQ���[aez�oCae��ܮ�{��-;��&9����V���uw=)��P��<N�vCM>���3�-,�i�eZ�u�V (�@���P����V�܀.w��d����л�����>��E �@��	(<|誇��@ir��?�[�þ��J�$��,]� �&��t��Jc�* �?�G��u�e�jktԻG"赩U������=%���������c�c~k��n��J���K�jTמHo����`ɂ�p�Z��a�Z��+*�}��ӷ���\�]:P2�,��O#Q
��e.�2�Z�� �8e��-(ˊ��Wl��-(f��#�2�O"�;#�Ƿt_�#x����w�9�zc�SCï�&�o����0�b�1�Ô.�S�.	o����SW�g�vIp�K��)��׀Knb�\{ߘ�^��Ͽ��>)��ް�C�_��5!��T?'mZ�������+,hk$oG�s8v�E�Hr�o�ߵ�?�/2���(��m�#���.#0������u�|�'����I� *L�.���$OR��\�� �`����
'!�3N�tCȩ}�G�Jt�$#��Ǭh�4p>�gϲ�O�<!�v�e���>v����<�ῳ0����o~8������������x����n�$��'��_f�43}𧎌7�t�Y�vA�(�&�ԍ�1/ _��+�|5Vǀ�%mM�׎��z��45�����=N��~�*o?j]���)'�an8�M��ZZ��3��)��*�䤀;�\*�B�q7& LZ`ڗ���D����#o=O��'g��� 7���׶��Mpy�����5V�X��a��X�b��j��`�
X~����Uj�~�y��k֩-�5�&�C��j�#��ɬ_K�c�r�ǯ_�X�`��U���.Xa������_C���~�p�X�`��X�!�n'���t���??�݈�Z��+,H6��%�|~�k{?��!���RJ�"�\&ۻ|�&����s>��{<$[����0�$[� w�����Z�F�s�����b����+�:��.���8�&�q�G�zG�8�#.���}�0�`���(0��N�rף�8;��r�8�s�/f_Zqޮ�%������a,��.%�ˁt�fL�'����o��;�0�K��{{�	|>N>�3� NJ��oͼ}\:�N�����]�9�{��g�_�+�IxAIJk�=%[�������|`!� �_Pb�\��<�����b���b'9ބr�h��յ���Q|����Y��}���N:�����U[�(yA	#��2�2r.�����@��h������WF�2r.�����C{��`������v�����/ޢ�����c}l)��Ѡ���~4�R:�|?)#�|_��ԑ(��j��t��ݖ��&��^ٍ��t��?���FA�_N�Ա/�(|�L=�d� ��ɠt�b�(�/˾���2��x)��袧�|�FJ�,����H�q��� ������K Y:8O #-�e�?>�����tW�P�XYz|���%�Y�A�YD8+�r"��V�|�3�.�D�w�̥��D���/'���˒;Q������.��˒"����3���"��7���gc]sQ�}1Q��1L�\|ߛh���~�\����^]'��|ߛh���|ߛ}q}�e
��ƒ}'������}�����c��o��ز|_Lԗސ$�}��_���~O�܍�/����{˄�cf�B�Y��c	}�ĖO}�~W4��F�˷��K�g_�o.�������;��_N�=���(��u��:�~,��Ws?��d��M����+3܍_�����'h;l�+��(��fC	�b�W����2�/�D��FN�ߙ%{�	�%os��(&g@��� Ӊ��o����ò8;1sIW��[z�:�-��7n������[�h��E����^Y�_��K�ۗ�݇�2�ׁ�=��\��K߾���`���{�C�L9�7ޗ&3�.��;T�l��Zǭ`�`3�+�� �'k�;����f1���Щ�I��S��Kg���,��!F'��q��JW�܉�YZ燾���d�ؕ�w���dÞ=�Ӎ3˧�'�$��bc])`DI��!�	�ﺴΛl�%�]����Wf�c=B�n8o�}&��0�C���f_tܵ\����\d�qIsD�R1�?e��p)�'�΋�>��b/�F�|��+��8�BD�R16�#*��~1����+�_��c����gs��q�>�Kٜ�a��BD�R6�~�8�|?��O�؉�_̊�qWYq.y��E��K���p;ߵRݷP^�!,��3R�1pF
)F�[_�w-*oO�On�C��n��P׍/z�2 �T�`�HqAjwC��E�oA2mC��������ݟ��O~�������'s�������)U����)Y���_��i�h&+���_z�-ú��S��b�kݛ.�ѹ+��Pz,�f3e��Ke~�% %�Y�>* �7Pq4T(w�ڵ'�P
fQ�n4T�b��[`�l���U(5~�xԍ]9���<z���,�x����;�������B���
�#z3�ь����iJ㾸ݔN�.sQFBw��;�*�����D��^�7p��؇��p�j4�*�p궃�V�Rp�jNh�.?*�w5経�G����}�X(J1>7|V�ދ��b��P�s-�m��߽����3�i�E3&)n4�����~x���'9��ԕ�O����+�$5��p(��dC���D�H6I�	8#Y
n�ɐ�$��dH׏N'��@��@`5�>ޅ�-4�Y����la�7
�"���ѧV�]��x�f�:VO'���i~�������s�����~o����׫i��e�6G_�����CS7=�|�Hw�X�`���%v����o�?�_����K��ӭ�W`��β�e+�e�M����g�[��3p���߼��Ì��˸���k���|۾dofY֝e���[�}}�iyo�W���&K�8p1�n]``��y��B���q㊆4n����\�
��.��-`"L��y ���p0`�ֲ}�������`���؉pG�A�#6��PF�a�SmT�4,��,X�T�w�z��X�A��k�{dt��$ �����a,2:�P�AF��:̞��d��Ħj�q�@��e�v�d�����t�M~.�<��>�{Rm��K7G`�������ڱ�������L�[����)Ƈ]O�t~�gg �R2H�W׈R��xK�2�;<���`~8�y gO!?��=��F}��G������d�����C���kt���wx�#����`Z���U0с l��2�-et:����dt:������    I�o�Q��l��&���/��*<�rxܧ�tM��ԫ8�Q�J���D]7��,�����>���}��>M�����k��y���}j��6����|���o����!TBX�Оkn�{�Jޅz������ɾ����˭G/�V�z�>F.��}������`tL����&�lSSI�a0b���,��0�tgp�.���"~��ϻ>zr䋵�����!�`��c�����T�����'�������[�-ՆYy�ݢT�n�W�Wsh���f# W"��+:"r䴜��o��4�^#��9�[�T����7ǟL���GVaM²A�@?2�q	p��5�L��d%��
�IY֤�6coF�D�T7��@��H���)&:����pt&W��)-\�����bX�֨{0k%��j�cG_�Z��ݚ�j2��������~�D�B���Q*��O��/΍�&k8�ǜ��s3�8�Ľc���=��z�_��Tڭ�H�b��5��?F���$����o��׵d��k��d������} �{R�?���_,�*/�ɏ����c"~�9 �p�c� G���=�ͬ�d�m_#�D�m�����mJ�f�v��SJ����q�� �C^��HŘb���3�=}Ng��y�C�,���)������s�hr����G?���c�_��]�/�j�d�B]�wNP��|(T (�@�\��	�ހ�"@��}Ua,��3P2*�YTu���U�b�"��*����j��W�U2~u�YtAMG��
�YhkR9
�"�Y�v�
l�[<��ť�t��4
�b�[�7�p�E2P���[H6x�YtS��jfu��AY��n�U|�:�f�[�
PfV}�H?T�@��2~���(P�@uY�-PPj��mr�-r^�*�آ���Kl�2
����~r�Ÿ���)�3[4�R��*�ݡυρt�eM���Ϋ�"�䪝U�ˬz������=���o�Zk�{�ӟ:yPi��3�[f% ���e�'��u!�p�9��e#>�b#�����Tp2�@=t����H�`f5��:�5ǮH풃�� ��A�]L����C�Kk�|�ɾ�崓}oR�끦����.(1P�C�v�b���.�o�f���etL"
PKP�i�4�|T�d�w���2@ec��Zle��Y�޽��$�(�:c�nf��.���=of�[�#@��:�Ex7������t��G@�%���q�c/@�����D��X�.L��=I`��<�<�#�!��&�<�࠷Ǽ��h���ڦ��Ɖv+#G����$Ӄo�RRR�etD����^np��y7%��ܮ՜�>ލ�A�pС7*�Me"pP2��|�u%c2��	>8(������+�N2���ړ����}W���l¢l����3n��*�N��B7���g�-��&��ai��G�M�
}�@:�x��t2�@AFU�-o_�|C���QU�~םQuCA�S���;�醪 e�u�S�^�� ʼJ�N�@��H5O�7�+}Pp)R�_�G_�'tagf5��?%��jw[��
j�q����)�C��O����S�g]g���S�[�B��̢�	m�U�wәt�����Kf��eH7��/�6�g�:���2@�� �6�קٙ+��ª���LQ)���0�a4)e8쳹U���o�G�S���lo�G���ln��r�[� ����Ԏ��
��H���h	ĥj�a7��q�fÁ���la8p7:Zq�f���u
��	��nYn�Bq�ձV&�j1!L߅�-��(&��v����j1	O�R/�K������(`�b\x��,�K�؄g�!�R-ƅ��	ĥZL�w�ˬ�٢=�ϟy=��:�e�|
�_�J�"��{u��w�_�:����O��|������>��4�gq�y�y>�Y��A㖯[ZE���\s�0�I��|J$���nd�����c���Y���-C�U������;i��vصO�w��]
W��?�Zi��X~-��3���s��s˶Zj[��g&���g�<�R$]��h�`���Sw�"���܉.ϲ��.`e�����Ԁ�{��[�:���2���=~�e��`7x�2 ��w��k��J��zi�h���O�e���'w����~G]��
��9V���E�C��&�T\���0J�BU��=P�G/&����)K0Ȳ�?��C<�Pi�z�������0z�@�j7�J2@U3+��֣�휡ګ�X�
P�@=�Up %���Y��=Tkl�>�z�
N�jvy�������$.)=��z.	�/�:z'�\2�˽ԡG񻮝|!p0��9F�ɼ���Q�A�{����N��^��}��ߟB�X��_[��r�t�ߋ���s���iO��2�h������~��w��s#�3����k���6�	r����3��P씐��wuf�w�e#���-HuAjp#��o!zi���>��iZ͎ށ�s���*�-��� ��HHyAj�1) R1H2)�E����Bl(�Z�E!6!��S�HK=�>?�ާl��[V���E*�/�W�ph(R$� ���7�1ƾ��b�-ɟ��N�	�z']G�ܡl��g7G,N2�Nґ8�☏�j�np���n
8f��I�c���ɀSN�S���O"��<�ӕuN�`p��uF>�g��3��+)�N㾸ݾ��tƭ[>P�?����O���e>2g^��|`�G��A>P�?a� ,B�i{^^�[p����0�����0�ހ���0t�
�A���P�.$�2��)8coC��@|�f�t��D�;2�}ʣE-N[�3��_�[p���0�<-p_�_��[p
�3����[p*���a��Sਙ��u��z��Y?G G�P��pL�3x�,Tco�/�v)؃|0E���<���&��qH>����X{>ȳ]�2ǽC��dc׏#��8�����\�3�`:%���S�A�|P��]7���Xp^��o����T�3v݀��:��)�)�_�z��w惹��,�!�:2-�s�RF�#�B5��ɣ�C�PM�놮��|��|ad^R<����?�j���P>�pP�y�����<+��{�O����~7��<�Ts�G�s��O0�3v>���ŏ̃[e��O1��?��;y/VD,N0��� '���UE"�,|��ȷo�Q�c�����7yl��.��O]�O7�jx'�C���/��ƣR���e>�'@|P�u�qh� >���y�;�l�ӑg݂���CcG�x�9��� �K�	g�����ҞbZ���\��`i�9���9��q|��`i�4�="��ď�>(��gh<!>0��44���ģn(_G��b��=�"�A1|�4������Cϟ|PL~��i>(&?uCy'��=������������sN1>�Ʈ��� =�м�UL2�}<���/m���e7a[��? �ڏ�G�����8m�w��~Z4����I��<���j�ړƐ`��!=��å�dڋY��C�1�e�=mՎ!�e/���8c8�(/���1�5����7�1��d�4{(�2m�AGy�,O���]���B��'����@[˓�,���>eC�W�
H�� ��=���>J)H�����Hm7e��D�3��cb��I!�s�a�Z>?>�1L�6��W�H#��H��S&��F4���#0Y���_���W�������nO��媟rR�^p���qN
�5�8���	�)&�$�1��X{�G\��o������M�ww�*/{����&�9SFl��yRz���e�O��%�6�
8f��%�8�����?�.Y��)�|�k˻q������M�s�������Օ�Oʌe�w��8����y�O+E��\�,���.�'N08a�� Ce�i�Cͭ����T��b���� \.QNi��r��p��O�a��< �  �\�Š��'�r�I�Y�&�dqʧba½���Uf-��R�"�a��`6��&��� S��H�ba.��`�#a*��f�{Sg�c,-���<���"�ƚ@	,L�&F� \�>Ə�AЅ�P`��<��A0��4�g2~�M�:g��!>�2�z��j'a�hd�o���	�zI�lFR�o���w���n��mHa��oM��hj5��M��}�E�m:�9��s�`�Of~��a-b$� )����qO �&�}��nx��gw#'��"���
pDs������;����H�/񠝤�cI��^��솺Qs�Q50#à���;Ӡ��&��h+�ܛ �Pܾ�o�f����7	�Ӑ͡so�« ~�	t�}0�7��΀���[���`�=L�Ѻ��}#��]��D�ˠ#���m�#E��x�{�g�{�{�� �2 �HH�&DAB�g��w�v���{��6�o�.���C���ۚ�uc��b��o�$����4��m͈~�j���o�x��ԺF��~������7ɷ�pg�a7�]�B�蛦���u2٘'V{`���o<��AZ�=�m�t���7�O��0��<� ����"H�"4��m��"��Mo��^<��\[�ٗ3q�����nz}iX1�N7�vx��iM�$IE@i�������	���ÑS�����)vLF�J
-�A�IH��{��L%y6�K���t�B*]��AE��|�ݿ�w�o�_�c;Hy1i�M�v�������c~?��^���3���qr���o�"���:j�0�LB�ˡc�@&��$G&���I:��C �$Ӂ�����y;&)ejLβI WU<l��+������b�FvL�_9�-1md a��#[��Eʇ��"�Ë������I%9+#أ��;&(E�K֘��i{�Z�l{D���)?��yz�ǩ����4����)��)*IU%Ǟ ���ޚ#�#�D<&2)�0�$��%F1�����:���b�إnaD%J]�<�0�����F�r#�nvS�BG�(V.�$�D���bOI�V�[�`�M�tz8xs�1�%v�l9���5�(a�Ql�p/� 7VnSb.����_PP���Z��Ct��\�m\P^��ͦ>����bhGz�A�����J�M	�1B0���r�(+V:�Q*u�qdA�T���,����vҩ��Ǿ�G%=�׆z0��������`��S��׳��$��n��g��A����_ZJE׭��M���sg�p�N��9q�E��/즯����Ir[�i-��_�mP}jG�e�Q�&�4+��Ҁ�5�QP��t��H�+(%����SE�3�T���^W& *����"�DZ��<}��	�vϟ��A���.��;=��P��R�����߭���u~����k���n��d����'WWW�Cc��      �   �  x��YKnG\���e�9�D�g��,H6`"�V��O Ō/ǿ8Ȑ"�?u��+�$���C�1`�Ȣ7�,���~��W�GnT*�ο��}��_o���Av�'~��K?�K?�:ο�s��!�/p�� �ǮZ/W�夒�\��JvZ���[0�ɺ�?�N`��`��]}�~��U��4�|�{tg~�p��]�.ܝ��
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
BOo�N����)£x�b��k�Q��r�aT{�i]�򒳜�Å�S�����G���9R�a\���yC�|�N�A^����˴h�"Ȭ�	!Z�)��.�6⻔�4�9�Hu,���M����]>���<뚪��:�\W�E��<S�90p�� ��I��`�r��	�1?�p�\�p�2�b��z�2a����?�����F��ݽG�����޽��޽��+&��Bv���v����=�5���91����@��y�jmm�j�����v�]�)|~a�U��p�ƿ�O���v�&-����W��~ܻi�C�w��ɼ�j�������o�	�w����Պ=<�֚�?WG�|!�0�u�ʞ��?�[I�ŧ�t3}f�>��|������O��A�<|��a��L�#>��}3��z5��$��Fm+��Z#&�ZL�7j���w�z��{=�_3Q�Wm굨�cj]��Du߬�#�O��z�D��v�7����m�f5��6&�Qi�D=Z�+qy��}�Hb�y��)9;��s��˿�a�2�9bVb���[�َzҏ;wc�`�S�� ��:j���8�_!�;�b���8      �     x�m�K�$G�����TH�W.�����7��0s��4M��լ�1��+��Ȓ""K�)�E��#����G���q�c}� ��/����}�/�tY_B|����C�&������P<z}����
܎����EY<E��xr� ��z��/���~�{���8�Xν�V���p�EW��� �~\z�`׎�F�1zX�Ap%��xRH��ú!�n8f������Ѯ�Ƴ�E4�v����PW8�Jx��@t��%9���r�HI��/����hRCs�nY�$����eg��%t�@���r{rv1�*G��FL[���0I�R�צ�sHˎ?��������G���L�;Y�((�#WZ,S�U�q����q~fF����S��P����(���_�I.����d_�a/œ���ruk�$n�'�C�.�
��n��Ҭ����-���eO�܊�խ���i>�_��.;�}�Z�tl�3�����l��}����g����Y`��P]^7��=_Խ9T�/g���P}�s����K�a�Th���V�/��ʷ_X���<s�h�KX�	��R'䭘xk3���y����x��a�y��,B�!h		!!�&��q����\��ٲ�Ί��*gk�R�&a�G$Ml�D�hH�� ,�� -�B�q�d�:gC�:k�	�"5B�Q��ZM��X"��\,�\-�\�,gL��s6Ds��	���V�ٳ�<��<y��|N�`��C�������{��RQl�KA��<8L�!r�۠�YR�%����)/$3y���K0�(�$h�FNDc��\ֿ�Ђ��
���ǖzT料3A�b���K�G%M�� <����fԜ�iy�����q�q�\gL=�$���%θ�/0�>�g�{L3.2Q�;%��VYɎ8�+�$
�g��k�������Qŭ�:�L�ǵ�]x�*Y(C\�%r�Լ'��LF�]M�7�I�.��w�'f����o�����&�}ot�܂�6H�1�p�X�P6�f�ض��T��'�W���~B�a@�      �   �  x����n�@���S����!�B�	6xc~T	96�^�Þ�?��V=��*�	P�H�i�WXިi���8���Y�h>}�Y~F����}��ck3q��o����b�szA/���;�˗�W�u��^����;�c�3�=>�=�S�&�9��cy��}9/�Q��W�8��%O��MQ-�VV�,M��(��V%+�p���iF)E����T5�,"�X̨����gGV+Ee����ư2�A�Uq��;�I��D�HJ���$t�ݸ�ݑ�S̻�d�o��H"�4;�U���kd�f�[H��CJ�0�1�3�Fwj�����������׼+~�s:~7�s&�	7�Gd je9A�.��$��#nY�mN%�Y7��l�M�m�DE}�V���7o��l���e�{{�Q��b��i�,�^�1|:��W h7
Ǔ[
_�������~3c4C�!�12�#�g�r*�E0f�L���i�D=�b,Z�G��Ь��c�Q8�	z��X��B�;Vd��`���J0�l�:z4W_���oWl�O0Sk��G�2C+G����ڐP!7�%�˨����9Ͱ�'y�j��% 0=��A�O�M�=n5�h�ux�3 Y�f�X:rݰ'4�'�na�0o�\�o�J��K��ۭ�c�gs��:��#������@/ pE����5������6%"Ӣ:.M�O��/.���FcE���� �.J\57�%!tf�➔��˲+�     