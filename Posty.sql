PGDMP         '        	        {            t-base    15.3    15.3 \    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false    219    220    221    221    240    240    219    219    219    219    219    217    217    219    219    219    219    219    219    219    219    219    219    219    220            �            1255    16654    qqq()    FUNCTION     m   CREATE FUNCTION public.qqq() RETURNS public."cleanSns"
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
          public          postgres    false    228            �            1259    16568 	   deviceLog    TABLE     �   CREATE TABLE public."deviceLog" (
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
       public          postgres    false    233    215    215    231    231    231    231    233    231    231            �            1259    16514    orders    TABLE     �  CREATE TABLE public.orders (
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
       public          postgres    false    225    225    225    225    225    225    225    225    225    225    215    225    215    225    225            �            1259    16535 	   orderList    TABLE     /  CREATE TABLE public."orderList" (
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
       public          postgres    false    227    217    217    227    227    227    227    227    227            �            1259    16636    wearByTModel    VIEW     �   CREATE VIEW public."wearByTModel" AS
 SELECT sns.tmodel,
    sns.name,
    sns.condition,
    count(sns."snsId") AS count
   FROM public.sns
  WHERE (sns.shiped = false)
  GROUP BY sns.tmodel, sns.condition, sns.name
  ORDER BY sns.tmodel, sns.condition;
 !   DROP VIEW public."wearByTModel";
       public          postgres    false    219    219    219    219    219            �            1259    16644    cleanWearByTModel    VIEW     �  CREATE VIEW public."cleanWearByTModel" AS
 SELECT "tModels"."tModelsName" AS tmodel,
    "wearByTModel".name,
    "condNames"."condName" AS condition,
    "wearByTModel".count
   FROM ((public."wearByTModel"
     LEFT JOIN public."tModels" ON (("tModels"."tModelsId" = "wearByTModel".tmodel)))
     LEFT JOIN public."condNames" ON (("condNames"."condNamesId" = "wearByTModel".condition)))
  ORDER BY "tModels"."tModelsName", "condNames"."condName";
 &   DROP VIEW public."cleanWearByTModel";
       public          postgres    false    221    238    238    238    217    217    221    238            �            1259    16567    deviceLog_logId_seq    SEQUENCE     ~   CREATE SEQUENCE public."deviceLog_logId_seq"
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
          public          postgres    false    232            �            1259    16534    orderList_orderListId_seq    SEQUENCE     �   CREATE SEQUENCE public."orderList_orderListId_seq"
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
          public          postgres    false    214            �            1259    16632    wear    VIEW     �   CREATE VIEW public.wear AS
 SELECT sns."order",
    sns.name,
    count(sns."snsId") AS count
   FROM public.sns
  WHERE (sns.shiped = false)
  GROUP BY sns."order", sns.name
  ORDER BY sns."order", sns.name;
    DROP VIEW public.wear;
       public          postgres    false    219    219    219    219            �            1259    16509    wearByPlace    VIEW     �   CREATE VIEW public."wearByPlace" AS
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
       public          postgres    false    233    232    233            �           2604    16538    orderList orderListId    DEFAULT     �   ALTER TABLE ONLY public."orderList" ALTER COLUMN "orderListId" SET DEFAULT nextval('public."orderList_orderListId_seq"'::regclass);
 H   ALTER TABLE public."orderList" ALTER COLUMN "orderListId" DROP DEFAULT;
       public          postgres    false    226    227    227            �           2604    16517    orders orderId    DEFAULT     t   ALTER TABLE ONLY public.orders ALTER COLUMN "orderId" SET DEFAULT nextval('public."orders_orderId_seq"'::regclass);
 ?   ALTER TABLE public.orders ALTER COLUMN "orderId" DROP DEFAULT;
       public          postgres    false    224    225    225            �           2604    16498 	   sns snsId    DEFAULT     j   ALTER TABLE ONLY public.sns ALTER COLUMN "snsId" SET DEFAULT nextval('public."sns_snsId_seq"'::regclass);
 :   ALTER TABLE public.sns ALTER COLUMN "snsId" DROP DEFAULT;
       public          postgres    false    218    219    219            �           2604    16499    tModels tModelsId    DEFAULT     |   ALTER TABLE ONLY public."tModels" ALTER COLUMN "tModelsId" SET DEFAULT nextval('public."tModels_tModelsId_seq"'::regclass);
 D   ALTER TABLE public."tModels" ALTER COLUMN "tModelsId" DROP DEFAULT;
       public          postgres    false    216    217    217            �           2604    16500    users userid    DEFAULT     l   ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);
 ;   ALTER TABLE public.users ALTER COLUMN userid DROP DEFAULT;
       public          postgres    false    215    214    215            �          0    16547 
   accesNames 
   TABLE DATA           ?   COPY public."accesNames" ("accessId", "accesName") FROM stdin;
    public          postgres    false    229   �z       �          0    16464 	   condNames 
   TABLE DATA           @   COPY public."condNames" ("condNamesId", "condName") FROM stdin;
    public          postgres    false    221   �z       �          0    16457    dModels 
   TABLE DATA           >   COPY public."dModels" ("dModelsId", "dModelName") FROM stdin;
    public          postgres    false    220   2{       �          0    16568 	   deviceLog 
   TABLE DATA           i   COPY public."deviceLog" ("logId", "deviceId", "eventType", "eventText", "eventTime", "user") FROM stdin;
    public          postgres    false    231   a       �          0    16583    eventTypesNames 
   TABLE DATA           C   COPY public."eventTypesNames" ("NamesId", "eventName") FROM stdin;
    public          postgres    false    233   ~       �          0    16535 	   orderList 
   TABLE DATA           s   COPY public."orderList" ("orderListId", "orderId", model, amout, "servType", "srevActDate", "lastRed") FROM stdin;
    public          postgres    false    227   �       �          0    16514    orders 
   TABLE DATA           �   COPY public.orders ("orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName") FROM stdin;
    public          postgres    false    225   �       �          0    16419    sns 
   TABLE DATA           �   COPY public.sns ("snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder") FROM stdin;
    public          postgres    false    219   �       �          0    16860 
   snscomment 
   TABLE DATA           6   COPY public.snscomment ("snsId", comment) FROM stdin;
    public          postgres    false    240   �5      �          0    16410    tModels 
   TABLE DATA           ?   COPY public."tModels" ("tModelsId", "tModelsName") FROM stdin;
    public          postgres    false    217   �:      �          0    16401    users 
   TABLE DATA           P   COPY public.users (userid, login, pass, email, name, access, token) FROM stdin;
    public          postgres    false    215   �>      �           0    0    accesNames_accessId_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."accesNames_accessId_seq"', 1, false);
          public          postgres    false    228            �           0    0    deviceLog_logId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."deviceLog_logId_seq"', 9, true);
          public          postgres    false    230            �           0    0    eventTypesNames_NamesId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."eventTypesNames_NamesId_seq"', 1, false);
          public          postgres    false    232            �           0    0    orderList_orderListId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."orderList_orderListId_seq"', 1, true);
          public          postgres    false    226            �           0    0    orders_orderId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."orders_orderId_seq"', 10, true);
          public          postgres    false    224            �           0    0    sns_snsId_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."sns_snsId_seq"', 501, true);
          public          postgres    false    218            �           0    0    tModels_tModelsId_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."tModels_tModelsId_seq"', 2, true);
          public          postgres    false    216            �           0    0    users_userid_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.users_userid_seq', 3, true);
          public          postgres    false    214            �           2606    16552    accesNames accesNames_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."accesNames"
    ADD CONSTRAINT "accesNames_pkey" PRIMARY KEY ("accessId");
 H   ALTER TABLE ONLY public."accesNames" DROP CONSTRAINT "accesNames_pkey";
       public            postgres    false    229            �           2606    16468    condNames condNames_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."condNames"
    ADD CONSTRAINT "condNames_pkey" PRIMARY KEY ("condNamesId");
 F   ALTER TABLE ONLY public."condNames" DROP CONSTRAINT "condNames_pkey";
       public            postgres    false    221            �           2606    16461    dModels dModels_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."dModels"
    ADD CONSTRAINT "dModels_pkey" PRIMARY KEY ("dModelsId");
 B   ALTER TABLE ONLY public."dModels" DROP CONSTRAINT "dModels_pkey";
       public            postgres    false    220            �           2606    16463    dModels dModels_unic 
   CONSTRAINT     [   ALTER TABLE ONLY public."dModels"
    ADD CONSTRAINT "dModels_unic" UNIQUE ("dModelName");
 B   ALTER TABLE ONLY public."dModels" DROP CONSTRAINT "dModels_unic";
       public            postgres    false    220            �           2606    16575    deviceLog deviceLog_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_pkey" PRIMARY KEY ("logId");
 F   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_pkey";
       public            postgres    false    231            �           2606    16588 $   eventTypesNames eventTypesNames_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."eventTypesNames"
    ADD CONSTRAINT "eventTypesNames_pkey" PRIMARY KEY ("NamesId");
 R   ALTER TABLE ONLY public."eventTypesNames" DROP CONSTRAINT "eventTypesNames_pkey";
       public            postgres    false    233            �           2606    16408    users login_unic 
   CONSTRAINT     L   ALTER TABLE ONLY public.users
    ADD CONSTRAINT login_unic UNIQUE (login);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT login_unic;
       public            postgres    false    215            �           2606    16540    orderList orderList_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_pkey" PRIMARY KEY ("orderListId");
 F   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_pkey";
       public            postgres    false    227            �           2606    16523    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY ("orderId");
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    225            �           2606    16430    sns sns_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_pkey PRIMARY KEY ("snsId");
 6   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_pkey;
       public            postgres    false    219            �           2606    16866    snscomment snscomment_pkey 
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
       public            postgres    false    215                       2606    16576 !   deviceLog deviceLog_deviceId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES public.sns("snsId");
 O   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_deviceId_fkey";
       public          postgres    false    219    231    3303                       2606    16589 "   deviceLog deviceLog_eventType_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_eventType_fkey" FOREIGN KEY ("eventType") REFERENCES public."eventTypesNames"("NamesId") NOT VALID;
 P   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_eventType_fkey";
       public          postgres    false    3319    233    231                       2606    16594    deviceLog deviceLog_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_user_fkey" FOREIGN KEY ("user") REFERENCES public.users(userid) NOT VALID;
 K   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_user_fkey";
       public          postgres    false    215    231    3297                        2606    16619    orderList orderList_model_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_model_fkey" FOREIGN KEY (model) REFERENCES public."tModels"("tModelsId") NOT VALID;
 L   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_model_fkey";
       public          postgres    false    3299    227    217                       2606    16541     orderList orderList_orderId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public.orders("orderId");
 N   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_orderId_fkey";
       public          postgres    false    227    225    3311            �           2606    16524    orders orders_meneger_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_meneger_fkey FOREIGN KEY (meneger) REFERENCES public.users(userid) NOT VALID;
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_meneger_fkey;
       public          postgres    false    225    3297    215            �           2606    16474    sns sns_condition_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_condition_fkey FOREIGN KEY (condition) REFERENCES public."condNames"("condNamesId") NOT VALID;
 @   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_condition_fkey;
       public          postgres    false    3309    219    221            �           2606    16469    sns sns_dmodel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_dmodel_fkey FOREIGN KEY (dmodel) REFERENCES public."dModels"("dModelsId") NOT VALID;
 =   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_dmodel_fkey;
       public          postgres    false    219    3305    220            �           2606    16529    sns sns_order_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_order_fkey FOREIGN KEY ("order") REFERENCES public.orders("orderId") NOT VALID;
 <   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_order_fkey;
       public          postgres    false    219    3311    225            �           2606    16431    sns sns_tmodel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_tmodel_fkey FOREIGN KEY (tmodel) REFERENCES public."tModels"("tModelsId") NOT VALID;
 =   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_tmodel_fkey;
       public          postgres    false    219    3299    217            �           2606    16553    users users_access_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_access_fkey FOREIGN KEY (access) REFERENCES public."accesNames"("accessId") NOT VALID;
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_access_fkey;
       public          postgres    false    3315    215    229            �      x�3�tL����2��/�N-����� E�      �   ;   x�3�0��V����]�x��{/��2⼰E����$0o�}�.l����� ��#}      �     x�e�]r�6��/��QM������f��8��T��⺤.� HY ���:�Dс/o�~���ꛋ|ܩ$���F\S&psՒ�W�fr�8���/;���^�o�t���pp�y �V�3���X(B5��������.�C�DM�b���a�]u�*�<�X&FͪE���1
~Fr_�c�g�	)H�\���)i"��<#2����Zvw�M�ˢ�e��ϐd�菻�a"�3��A�/;1A��Ţ59���h�+%P�R�ɗz��=K�h�3Ń!�$�+�l45-�W����Mi/.{�V�� 	雀Zo.��<�;�rr� O����,F���ك��R��o��
hHE�5�)����s�~u%Yp:�y}w%O��X���:1�6�V�V?1�V�y+j���,�fqb�,M���!Ұ�X ��ĸY�5k^������pb��C\�cY\��ky,�5ʸ=z��*������#�^�,B�� j� ��� ��>Npe�4|���ay�:+���j��u�2��>���/�wg�!��.�{Z��������)��J_�F��^>%5��h֔ˊ���O�w	�Bh��~��ú��]�H�>j,�S~��OEO �P��� ���K�Sqi*Q)�mCW�7I>�^?z����Zc_#w�C�j��	�pN>�X���@T
�H��m��*� <�	��D� A �౗����. Ŏ�)N���Ab'e'��>�nh��sFy�G�+
E����8TՓ��}y��+Cu_�}|i����`�+���X.��d̒q�}���4GKv�������ܳ_/�]��J���UhS��Q(ހ%
��D%�K	��K< �4d�w��x��[[���������~EBmG�?���c~nϢ
�5=�ʝVz	kК�h�sAҚzTjy��Sh7�bPcT5
�gk3(j=�E��� ��P�ĽZ0HzE��d���I��Q��#}Q��AdD�5�\����J��A�Q4H�'����?֟���[����8���_�~w��Z���      �      x������ � �      �   >   x�3估�bӅ}� �ˈ���[/6\�za˅�/lP��I��pa�}�.6s��qqq jK�      �   +   x�3�4A ad`d�kh�k`a��*X�W� �O�      �   �   x���;�0 ��9E/P�$@��1X��I��B܃��ЍC�7�M�t@@�8����ND��S|LG$4�=ٮ?R��Ѐ�;D��X$�T�7�l/���٫��%����Wo�,�b��������*�Z5eS��Fi�,:+*ڠ�c��w�Ze� e8��hꎂ�$�y�m�k�9��#7�֔[��sDZ9o>���8N.��cw続      �      x�̽]�t�u�y��r%a��V�_z�%G�P"�H� �*��'sc"dl�PQ�$B�$��!!Z"i �`?�h�vw�Z�s���uz�}����ܿ�����UUkW��G߷^렔2!n�N����6Zo��������3��A�~��=z��ۏ�S�����/��z�o�����#��+iK�$s&EU��B�D~'L�@
�t&9 �J��)K�d��%+L
��v3);A�I�a�#I�^�$u$2�Oc����mr:��$��`�{�a����k� �*$:9��g�h9$0H��Lz��AYf?�F�a��f��fK�n6�C�f��>��졛���L�r�9�s��p����8�s\�����x�	�r<�rp��I��('���w��_9����h{ձI�9�i �
�EY(U��s����A�	�U��mM���eBQ�D�AD 
�q� �Q��墬= 
�y\�I&QHLLc���	Z�곧��k��̠�^D b!��ʂ��&����%�C�/4A@,AzէBU`��z-�.sd�T�IG%F ��Z.Q�B�Tg{��)�B����}Epk�,�
,�����
:��Q�,�
��A���O9P*/�E�*b����yjhyfO���8 	����+N[��@���p��&(W�'���Or 	��;u��=� �`�#�*��2G�}��R�`YZ��Hm�@,+����:�˪��jMh�cuݣ	O]5�Ռ$Z�;�Ƕ�薂Ip�͏h9�A(0���7��RvJ�asT���4�A�6d�c������g����mX�a[c�a��r�:���,�<��a`���V�a�b�Y%��b�U9�6�/������M^�n�s��O��/z��c�Jt����߭v���M����dÛ�}��3�t����9~���|��#b���3q{������Փf��)�S�����آو%A�[�E�b���mv�e�-8 :F옣.���2l���H�\G~�2��C����o?�0~9~3~�y�f*��f�U騶;
���\*\5+q�I�A��U݋
0�b|��Oc�%�`������CV������/��ͷ���?��wo�P~��/�~2~�����yP������g�W��]��}T��AD�f�� D$+텲'-H� U���Ar�Pb�E	�q����9�����z�# #���H򙂌���ț��w���d�����O��������?�1�M���m�������v����EI��烇���j�-�)}O�����ݧ��U1I
H���¤i�"R�&������Ѿv�L��HW�CyŔ������ۏ���~�M֭������#8qxp3ܔ���p�j���R�[��
�E��f���jI��rr���!
�<�Ru�]&pZ�HGaR�b%��;Ix`�)<u (�P���Z�Y�Fy/m(J�fQo�Q 0ְ1=H�PNj��i3p��C��Lb+�Av�f���u���(i����Q 3�E� }��LT,��s�Ѷ�D>+K�/���/o�1�_-���@e�6��g�)�����;7,H5@u�j�T#�
9���������leZ[���W[��.9��ĨfAj�fԴ���JM�Y�g�5~bj`��M��bL��"���a�хb(2.�&�Q�.�,ߨ5�@�"SC��BY	\0V	J�ļ�/9�PEV�TCJ����\�z1�4K,rBX�
K�ĳܒ�N{��5e�kZI����HS7�۔���S�Ov�\�{�8��.��>'=��VN���(��WΠD98�r�Q��c+'�r"�6?��u� �p��ASl8�MmNrMM��*hG��$�TN�D9��E�^���ٸe��T��5��#�$8B�>)m�@Ӹ���(x�N�4�;��}S��8�o�O�Z�_]Ψ>�iq@<1�hRu 	�i���Fh�cG��΁&8�=C�A-J�gw�8��#���i�@!�'	Mh�c�}�-H<��c�¾OM��A�f#'�AQ����A4��(C4A��ecȃ(h�������(h�tH�K.����aw�$h�{�*��"(��-��fk�h� �(��-���U�;Q��*��U� ���"Y����u8Œ�N43.��b��5�0���ԡO�[�"S�]�^B+�"H��0}R��&�X�s�&w���lASӝhIA/�EאD���nE�]�*��i�ڮ9AP&SӃ�ˡ*����}DY`�A�bL �d� ��JX*�Kv33�,����fYY &IV��ߨ������(l(Cbs��,j����{루�&�ȦH�n���x���;J.YIA�F�
�/�5�p�LR��Gis�û�A=�6IA�F�>V�>%���&(�R����t����)����кLaY_�-hIsx�&v��S_Rm�� T��GQy#��u��^p�4hAb�v�+���$�@F�ЂP�\z'Z[�1�,�M��I�I;h���ѤAB�F$W�!e�m;�.Ҩ՞hD�HC-�WO7	����@�H$���@0aHA`uξ��j��0	=���5A���ۮ�m�@"��J-6A ����5�ŀU {�f����F�r��b���Zχ�f����P���;n���|����|���d����_�9��B��<u�|g����o@�3F<���~9�Z�垹��Y}�f?��~r�Ë.�=�^H����u�ݾ㟀L�դI�$M2@R�4���I�gʅ��^�����5�F�-.6�7�]�į��8f>����1�S;��ūg�٫� |E����N�KlÔ #ffN*��r#c�Kb`\�ؽ ���7ONń���L�}:�Ң���zW>Y��nv����~��ǎf������*�n������Nٓ��X�w��A� B�%� 13d����9�GAHH����$qH�
�b��}�B�pm��z�*�M� hɔ��Dے*��7���`JY��S�gre��9]`��)�/���f���A<����9ݮF�	�<Kk(���3�lL�0� �,2X��y��+�Wv+i�@��8kJ��Ҕ_J�V_�;ޕ��,x�v�Ǭ��OM���i��e����a�_N�Q������������xO��kw���'0/U��n�N�~��3ޖ��V|sMtj�;c�|�D�|	,�!��f�JI3UAO������3D��x�{��������~��t��'y���c��al�8�q�����iy�=ح�ݥ�����W���68c�~ˌ�wao29;2�������lq��p7]s��}�)���N�ߣ��׿)�S�2�fR�[9����,Pb�)*��F3����Kr�����x�4��deA�����$((2��E	@���,h�ͫ���n';tSo^u�\�������s%!ְa++I��b�-<l��<y�`��
�U�:P�,r�C��מu�H�`�*�KU$A�
ymQ�[�N�y�)Q��?짫�6�^�G��U��\�B���AOKB.K�}��� �� ��R�m9A'+��	�k�'��ˊ�,~��}���g�o��b����𭼒�ݛ\�����-�����~�W���e��F=}�g�_�,�u٨9��lu�-V�zqc�`��yLz�w}}oN�:3�WH9��1�B�HA"@t�XAK�es�� ����,���SN��nޞ/gO�4��
��	gN�9�%�Y"7�֜�\�dt)�H�#8��&2��%�&1�NoYė�J)D�eO��@Ļ:\��+(!�x���&�4�sa/'�o$D�eq�d� �-��(8'��I�@�;'Q.�D�c�J�F������ '+�_s���͉���w�f�\��x�D.i�xD.D��"7�#��]Z.ND�f�.ϋ;kq7�^�==a��,c �U��a��x_/[��`����g��wY��z�q���������^.�-D��"WHX�xUee8D���9��*1K�d�B�׵���.�Y���B���n�    Y���A�+S�ܜ8�x͖J��[�M����l��d�A�k6'J.�x��ZN�D<�����xbK-8'�l� X;�xb�]���ϊ� W�y\ǳ���=D<����=�ܱ�2r��1�Yy��.�x�]�4)��vS=D|bs��KZ">U���">UN�;w">��� 	<�K�[�ȹp�������U~�Q
B a��)�[���8iA,@�89F�b�u���:~.��%ALVB 1��IP��g��V.���XfI�7,��C������Y�;����E���"^󈗋��Yė�ޕ�@��x/'+"�X����oy�xϒ��ˌ1�%�Y�1�-K ��t�r�$�xVܥ�jX�0N�p9A�m�H$���^N��-����q��p�w	2�ggZNn� N<;n�k)�
V��7ɵ��sa�MNl}b�~=;n�[Y�_��'VlajD|`R/'�;��+�#a�S���i��ŉ�N���ъ	��N��TX��b�Z�G�rs��j�͉�@�G�/��;�"�T�r��j����~��N��� -���l+j+�ة�w��Y�T�l�{+8\���	D|`���v���\0b�Z`9^��b�Z`Պ\o��N���V�"~�T���龲���M�aS>�{y�5Av�V��ʗ��)]8���s�UYB�~���v���!˯���u��z�=�|�Lr���0)�VR��%%N"F�7������t!���c����g��o�5~>����{3}���o?���������շ�~��������#M�,�y�o9�)�F��m�t=������\�ì��3����t�/J" �L�>h% iF��$$5����]���##m�IH���}/ )0��<E 9O�.R����;N5�*l����w$����(N���l�P/,S&i�@/�f6	k�=�ޞ�ɕˮ�y�T.q�$H��U/�/�DmB���˥G�"T� �{�ɱx��	4"YF�u�#���.t��e}���:Ў�* V^ڑ���Q�1����	�����b$J�,��ʸd����|D护�a� ��� ]�9P�IX�<(�c�%]�yP�X�&�Rx^e�J<(��+-a���k��G�Rx��Z�����^�x�	�*'-�{��)�x�F��l����r��&�F6O$��hDd�ge5���eҟ�=٤r?�N�x�v�-���!=��c�7�:�왤'��&�q���~�R��	��͘}�A����˥�(�i�uOCqȲ�/�=qR�����o�܃�tY�y�G�I�'����Oz���9lCi���w�;m�߅�˴�M������.ɮ�.�H�9*�+���w!�.����8x�a��u��\��������,Q�p=pg?�:�>�Ű�u��K���k͇�U�̴<_u,h�Z�'-�U�l%��zsn��V�:�q����|���x�wY��pM����uN��6�@�bպ�m��c�u�j��Y-�ľZ-��>��x���c�k�jmr�@�:l���x�A������4��oy�����Q�<�#���`���hخ�.P��jZ�~YM;O[�^��~�S��)������v���r���9�rb�̕�D�){N��AN����7������i#���-���Z�c`~R�$��r�e�v������mH��k��m;�r���b�����_?�$'*�0?(��9\����;�Q�G��?���t�u[���w�S�M����VN_�Uo����I�W��4uu����h�D3��sI�,�t%�;yDIH����d���\�p�H��=z�y
@��#�0)��YfS��7H	l�,��=�:)�3#���O���P#,�I8rh�fq��	4b�A���&�FT�u�7r[$��H��@#(0�����%�J�&����FUm��^Rh���M�Y�:�ܪ�H,����[$$�H���"�#��\��F�P����ѻ��^�F�ZG8�V��M�����fw�P#"�\�y�hD�;�9�Ut[��v��� q�p�F����'��)/6f��5�a�V��+ڙ�=O�MZ�WR���l2@bAңg�T�i�#Z$^�+iߛs[��d�Mң��0��+�	IC�j��uyYor1R�5� ��n�AHl��IH5��]��Sc�<�<���  ���%�rRd�׭F� ?�9k$oz뽆F�y�;kyw�m�@�-#u�5H��Z�*LvM�-��c�=
k����X�����"�<y6O�^�hdB�eV�Z�	���*,'�Z�	Ǔ#�'�<Bx��(��Gᵆ�l�Hz� ?%�~d�¼����^Xw~j� ?%��7�F�Sb����EJ@b���uD����N�Nx�<԰����6���׹5B1����C�i+�F�Xӈ�����������aV�3 ٽe��FU�����85{�gLg�N��O�=ܦ��S�Cx�Tz��3�w�S�O�zu���pJ��	��X��VN݊w=�T��t�ۦ	*���a'�PA��1�l�
"�=�l��lϣ{=�"A,[KGn�
"�� �F���؉��
G.t{��tO��"jӽ�pU�.0���ok�P#X�ս�nhģn�W��hDd�J���E���V���.t{���3�;{t{���3��n�Y�J�C���|=#�5���E�I�,�=\d�����]�=T���4������Nu��3����f3~>~1~5~�f�������v�z�r���g�P�����I�Y��o���ݖ��i��S�2g�x�<�O_���Ai�Ѧb�/Dߌїk)��H���4���1�<�s�=������Pa���V=]��Y��t�)%<���8�+M��y�s��Qm\�g��kW4H	H��J�!I�n��$[I%�EIH�l��Hs���u�^�S(�U����٢� l���%eIl
̦ L�@��t���Ԝ� �8Qx��Q{R"6ƪ�1V�������0lU���Nr����=2�����%�x0M���,:��^�d��+i��x7��B%�%�<�b%m�e�����G�����L*�a��$�HGY��1��JM7� 9E��	�d�F�X5b�eS���_.s	�])����ڔ;��}����s�g?
���`<���W���+�
��+Dx__��^!�WH���=���_�*�
�k�W������n�W �
n�W0�
���ٮ�
,�y�a�Ӈ���]���5�f��wl�X��Ĥ�\��iTC��Ka0]U���t`�r�L�A.�H��:������M蟎??9�������Z�S�83���|!f?C�����C�.f�l���W+�ʻ�ӵ�:]TI���9�$i��<+g����s7���٬�Bϐ��3w8>i �
2� P���� ��@$� ��;B9y�9�͖$l���u���s(���/%
�"�:tQoeA	@�����M����~F���se{:����c�3W4L�t�O���Jb�c<���^��p�ucD��3��9����j1��4%�	�I�%1�*�uYs��6Lw�T�a�.���U �
X������js���4]"6hT���ɮ&���54[C�B]�T67$�T���1�q@�f��5h-��g�iD�T���4]��
x��k��*�yZ�T���g�I��&b-���I�@�Z��As�sc��PN�t$�3:�)�tѴ�KZ]1;��`�B]���D�fMW9��$�؊�K曤 �5���48tu���!9�F2n��ld��@b���Ά�%P���}�f/j��� ɒ#�
ŤS��@���*Nŭ��%P��� 87Q�
Ī�W�rP��*Fpn�(����qщ�@9��1]�z�@L#:h���M�7QA-���ա�&��
L�>S���`���fJ��
V�����=jX$V�*�AӰ"H|E �֢�Abs�%�FÊ ��.-��˞ZR�4�(���ۨ=�g�����a_ �}-�Z�    :�5����5�l3En?DR`Md�H�i�$��]��c��Ac cF�("�LU�o%��8�a��C��\?��*���K�Z�/Yr� ;#D�NJ7��R��@-�Y+�"0P�o��bc�̚�eT�@��پEa�@0�IM3pF,È��Ի�	��F�@�#x�B`�]�h��a$��;�Ђ+т
DŬ��:-��xu�K\*Yթ$ڂ
D67J2�YP��T�(��,�@�kO�|cA"[{*����=���XP��מ���a-�֞�+<*�p_���+��0X$�В��a��e����S����U�~Kh�/'��6m3zj.�=�������.� ;B�3	©�MCŎ�u8쇸��Y��Ui�~v�~�O�(�$�j�t�*;�%1�P��|u;��Ֆ�ԏ2c�����`0��Qf�c�x3D��9��n�f.�3����a<`��R��40�m~���*ӕ.�ʹD�$����C9�{ԩoZs���\r/O�-3�2��1� I�aNU
~1LU	LU�A0ܣ�X��S�S51�*ln��IB�AS�ŋ��
/g�!�U���Te�'�5�Z����*��̱arրD�0Frn@"�ȼ�4Ѐ��|�-fM���N0���] �̋�����d <M� �����	g�!��N�M�x����3�F�?��̐����~�v�x�$2K�$ $1�^9d��� 	 �B�n]H�:Z*�y��4@����JS7K���r�!�O���@����� �F��@�[�d�(��gå]"~>"/�bI^��m�̫{���x�r}�"i�`BL���P�����@(>Xrʥ!�g�1\�/����~j&��@�x&�ZpV0NX>�SZ�� ��2��"!G��+$A�8�~��(!D�cs���D(���ZV�l⇎B��Ѩk4�]G46)<Ka1۲t��S��N� �D.���ۃP6,��8iͻ!��r��ͻ1 a�5tDc�,T�ē��c̳���"�¼k''�"^s��K�"���npr�x��Kn�`!≋�\Qd1��pu�[�b!ͳ��;9����[lY#����$ߡ]�т��ь"��,$yb�_A��Pr�Vsr�e��&6���ws0ͳU�Ux�n�{�!_-s�
����6���yv$9���%n��%�nX������齃�O|kB.s9��
b�ؚh��=�/'��]�|���O7��lʐ��AK/�/���M���\��[�)��ڗ���\@��},ʹ��T펲��T�N�YD��y�+�^��� : � '��ul�]C�o9�����8�����ތ��_��Ow;~3�v���W�
uPZ�V��?za�r�deAB�V79�c�PN̢�l�e[�蠄-⡬�ZdM�%NB�V��-r��#�9�p,`���A��:GဍG��^ဍG.1�d�(By���AJ�Q5[�Y��!B�Z�:�	�8�����9�ė\խ0u����A�K��I� `�f ��2A�FfQg!�A�ƚʏ��(A�F6t��V�����[�� `#[�u&���A�lAc�-e��0�+�b����x��jag;ݮM:G�i�\ooM�,5ړ3�r���#�F�$�IsՐI��4���U6������9QϏO@2��I=�ʐ��L�@�����řt�J�3N�.?|�n�m2��ش� N�|/���t��/��)?�����o�2)�I��5��JP��Iz򃦏H�8i������$$SI{i�*i'M2@�l����I�ѓ&9Nҩ��}�)VR�'
@
�#�IH�#B��5Ii���:�~��|�v�aǃ����_'��Q���������ߌ3�����������V�ه�ӌ�~������	��j�A�C�`#<����I8���$�+c�dI�&�IFϤ�Z�y�@R3��f�&)p%F���W:U�0��&<\�*8�b������/�oƯ�``i����2�* U��ғfQ0+ڤIPv�Z����\Y(:b-���B�j)0l�IPt�Z
Lω�!0�p[(:�üL�-ٚ$(:󼮒��y�,	��zSb�"˒P˨�7j[��`YX4I'_�����	'_
a5[>J�
�Y4yi����XƐ�=Pϼ�K�@!<���B3n�g�	�J�@!\��monj�<(��c{�&�BXF�
ǭ��5�����&	³y��	��h����&	7.���=P���VZ_=*�������E���U��O�F��F�t��.��9OjdN��9ؓ��7-ة�ɟ�3��iZ�0-4�at��S�K��ݖ�`�c�yI� ���>��0]aj�a� S��e�1Uo\�A"�堺�N�/�0��
�~}Kx��c0�9;5C�0�d�`��v�����1�������H�@A�b�,�5�mZ x���SL>k�~�rR�j�0;�t�[N
�g�n0��q��5��io� �@���4��̊��Ÿ� &�g��?�M��uƦ͌r[�M��}�d�+V�;�����<��V�}����2 ̰�S=s��~aYE���BM�JM�!�Z�D��
$������Fi��Q:1���J+V�Y�}WH��Cw�@14S�/�ףX+P]c۟3�,P]c����5�PxX�ZΫ�[Iڴ|#�YT����HbZ������S��h�}b�y�נ�{�l,k[A�g��.�A7,K�/(�[,���V,-Ȇ��x�/�MȆe^��-���2���-�e+����C�aXF>ʖ��.�l_3kB�`�p�'���u'�F�e�&�#���ajѿ�גv�0�z��,P�Ԣ��9�@.����Fza�^l�]�%L/�ld�/"�ZdP+� ����;�_���}��r^����i��y#�6�4��~Ư�_��zB�@�3�r2usA]Z0�� �f���ή�<C�X����e�a�����/��}������O�����^��&6T�ܩ6��>���M�fo�6j-ML��\��T�DIV�I�J�l����)N{��$8Lql���/�,���k�4�)���p���L�V�x[ϤN�ղ�h�8���Q���ax[��Կo��86�CKz�z��ӔL>�Y�ְl� g�)�4/ ��6l����~�a;l���3 W���([&��z�cެ[�gxf:������#���]��#���~7l�uU�?�>t�S��B�J�;�/9�mb��L��iW�����3/�$����(��o�hmBy����Vy�댭��Y ��D���z(]QQX0�����)J����㌲/8�m�����=��l����7��ݎT�(��$�N�HE*��={j�ߥ��L�u��I������$A���#zc�R�)TR��7}σ���{V�4[6cb��&@����却Y U��n'�~e"0��)B�ծ��IPQ��~�Wd�$�Z����MH�Q-H�y��e6�4��x�/v��n���E^�:$�ϋ�n���	^�s�2�%]����.�&���ӻ\���b�,K�#T�x��t�2��Zw_�'������Z���7.چA�鹸�{�k�X�����y���M4��ŷ��QK!K)�-�4_e�P7/z�k�E�:
ىn��C-G$�ɒ�bo��H,�`>�����i�5��]4v�/m������`��.�t]`J�ЄT�l�=�0�v�0WaI<g���J�X�E��߭��x�O����v�C�(pC5��r������f=�^X�4���ޝ�&	jz�җ��	���^O�F��5�_�~�t�I0�|[���i�6�6�8����͒�=:5Rٿ+�g�?UL�u��	�����a�N�2z7�d�At�)�a�¶���XaS?��TY�*V�vX��L�9����дRȩ�p6+1���V ��	ϠRaW�����+l� ��E4u��c$�ЀZD�IT-���j���g��T5h������$2᪛�m���I�    ���mr@�N�w��ۜ'$b6I����3��$.*T���&a5�X5!<zV��D$+�+D���3H��{��iAt��ݼn���Aѳ ��C蝤&	"��3҃#I�j6�mDI(���S���5eL�=�$���D�וj�X�<t�*7̓�l�:˯&�,p��I�(2-�_k80b嫬�; ò�l���lMjd�@\"�/�^@�76�	���d:K�&�C�#	�䡈H����M�����6q���w�g��5\�C-Sr��As��z�9x �V��W��$P�PI&J�@"B�r�YE�I �:��̃MR�*��? �{w"j���)7@���Q�&(#�f���B#�B��`�٩I��*���&"x������l�+[U�ٝ�I(��dM�PBbC�e�^gl�����tM���v",+��0XjX�e�t²�r� ����0����|�_+�#nK�¯w�tz�IW	�[�") U����Դ)i Uw��es" �(��U� ��B�3H�@�l��=�.�r�]�6GσMl�{ ڴ�kDR,�z�M�"�T��J'��d^HAL#:O��$�b�{��$�F���@#�iD�vl���G�F�QPMD���՟Q J��.Z��l�(t��cUDbU��ٱQp���*�W�5�Ѱ-���Fo�6I�-����M�PL_������v�֩�M�b�I��hV�w�+M
SW���XB�����%�J�d�S\�$(!+������Dd� ¥�!<�dgǝK��C\z-Om�&l��U�9�΋/ra��O���͖��_/e����R�ػtZ�0�.���%0�f�3��֠�wv̥���f�E�^9�����.O�a�wH���r�Le��cn�<�e�Y�5�Aը��s���1����-��Y���V����1XY��ti}����^�t���1�U�p��1(�i��b�X*�3���>5w(X��{,ڴ	>�g%�l!c��`�c�K��IP[(�!ܫh����	�����/O�ñzIz���H�[�M�@��@��T�E��&�mm3�_�H���}�A1�R%I獹���{����in�<�t%Io-:\0����n�P#X-+|(`��2��ޙ4� ^Hh�v>][(	� b�v��cMPP�-X�@�fm;����z05�
fG��a*�j��x\s��'{��&	>e_	���l�L̤N�k���P�O?�����h�Ԭ�n�m�k�@'X�йo�:��f�5�>8�I��Ca����c���A��fW으��Ү�v��3yX� �>z�����(�8�S����l���fL��v��X��#A���@/�fP.q@Q-��u.��V�ZXW�����}ʶ���k��G�4gP画��e�:;Û�)���з}����&b�����E����doJ0�!��'CgA�A��[��(4H�'�I�a����@�d��ř���m�{]#8u6�I�����K�6	ĂI�{u�Z1��j�?2���ɥ�	�
`��~j�,�G��Y�����[�#I��j����B�f��Ε[�_e����'m�#����D������k,sr��v���Y��n'�a�U�c�6��}u��^I�n�dM��r�� [ Y��쎢���	��lת�D�	�b������I�b±m+��f}����5�IR��k����F4C�d��${-������^3���i�@(\����B�d�͑٢��&�����p��)�Up�l����'l���-����=��}��z��*��ڸ/גU�4z=�Ə�Zre�u�.�v�z�ɺ�I���r�ti��~��6m�O�=�yt۫GM�3�ӷ�d5����=~=��������������O�|+��g�Ͽ����^ȅ�vʿ��ʯ����wo�~������߼ɯp�/^��i�������������<��o��Y�7�ͦf~�7K�f����:;�7K���p/�7����0]�̽������ٰݽ��x3�ov|�7��ff~�A��l:x3[�l��cƕ�l�_���;�?g��fa��Oh\=K���P�{�I�B���TE��P^:���_�Wʯ�>FZ�0#����A�Y�{���������k��,����Z��t���Is@�J�'�t�wP7�������[ûA��;�x	:f���x����Q(wG��N�r a������􄘋�%�� ��wd�w�@,�����i �fh7,A�8Ҟі�7͂d��m�Dה���yH񚥔��m�6���# C�9RX�|I�ʗ���BHzV��Q0��	���4.!nr���^iA�A�<��{���5��=�u��5_�&ޣk��H���?���&@5�k}�����+�K�P��
~�<@�\��d^ijA�b��+9?�cK���!`��jѰ��1�["�G�5�t힚�4-ǖP�l��HD�1Ѻgy���9�k���=/�g��ݱ�p��:ZV�ұ]Dud��+�uu�L��ݎ�+�jG�Jj����O�+�t�M���|m�:������s��k��$PR�vǖX�&.�Y��Z�e�B��pO�|�A�E��^iI��;������"�P���J�?%x�*��ur�S
^�X- �Ni�Ui�,��IC!�K�g��j=��4	�v
t"�Q��(��-����;�2CmY�.Yi�z����e��y���>"o��-k�{-���omY�t~�{�W�% 7�8���A��O̶W�!�S�5�ݱz�y3���-�/�U�=˸wҰ��T��UfԱՕi�%�țW.?����=�C�!�������?�é�8��V�*�z�Ł#؇S���=�w�l�(�x^�3�Aw�u�j�4h̞D�2��ӆ����I�Wz!ht��-D_��������<e�,D�� X����@I�Q]~�h���jv��X���kW���]~�j�{��{�
vw��{�(�ݝT��/p����[�יh/?EW?�z�����l�t�J/���=��n���{���y!���6H_���Y�<c������B(�թ�=N�.����N����bؓ�g��j�����s`Ta�_�``���e;�����U�'���bG]�a�槬�Y������:{S��'\�"=�d�^�3Sw�G<�a�/�X����ϳ�B��2�:�{Cf��	8����L�k���!�O��h�wp��S��h�wp<�S����h�� oV�ct�Ѻ̛�^%��a�J@3����Q�O5����e��n�ovG�%�f�\,�!�2oƕ+(6f(���e�r��� 3�r���+_����G�r*����7S�~���[�����é��L�^����>2m��YK��@m"��;vIތ�/����'�K��L~�r�&����J�w��4..�p&�#S�W>��U1�}�7Ú���+_����8��ff��%�ǁ���p<�b�-𽞇3�k^7��z���H.@�S��%h���5��׮*�:��+�:=EͲ�g�Ι�6l����U�K�1��4ӨW�����oA�,���N��bz�����)�k����N���zfX�{8��3���F�zܐ��j8t��%�W>��W�l�p�8ȼ�\���82�y3X���鎘�y3�>��앯��pd�k�9���p�k�>t�y8��5�	z8l�u��a��l'�^�+���4X���l��op�k�Z~�q�g�^v��y�NhT]�����p4�M����.O�u9K���f4_��aXb�
7����vK�48�bZ�Ě.Y�Ĵd��\�V�b�K��7�bZr�=D更�PՒ���-��hK�h	�#��"^�uIՒ���a]Y�-0op��K���'���U��K����y~���Oe�]�rS��!�ٖ9�6����̛R���f�xo��q�	5:N��{��wi�}���{���o_��1�����W�����y.����K��=�X�~�    /W����k�BS�K�$x�C9��Ɯax��T���+Vl�ӹ��$�z.�b{�;�<ܳ�K�K��={.��\�#T��y�4u��|<ܳWڊf���y�D�+�}Kl��y^1=[��n��i��v��-ӝ%��3/Y������J�%l��/1�^�8����@�ě�=�q�]�C|Aw���z��yS5n�Dn���Kl��=\<�}5��_`�@s�6���ep˛gw�yˠ���k]�0.`�즖�a�p5��F���`k?�|�0,0� ���%�M҂�x� KlMa�~`��&6�+R�G/؀ϮH�l�l�gW��+��Wi�of٨�nbƾ�ׯ�[�� �ێ�ʻE>���ko��g��.%����,�ί�� �V'�k[��伩��8T�!��E�~�,�����Uǻi��c���\e��߰Ӣ%�v�[V��s|����c+ɗ|�{}q���[��s�Oи�c当�P�����8OЕ�-�:�t�{��z�M���7�l:����-�,�i�[",���{�;�GN|���ش- �U$ۓ��"�+���:B�#l_�'¥a�|9�t���V{t�+g�y����W�m�_=L����ߌ������u��ތ����	^"֗�ĥ����+�@?X�%4�D�/1��/Q�#�_��K�:�}c���+����0�%�/��K�sŗ0,D��/��I�%̊/���t"��S��X�%P1�cnכ���|"����L'���I���~ő �$V��V	PL�F�V	TL���H�b�_S��p+:��T�'�z#�@1����cx	PL�R��5��T��s+:��4,Dӊ/��X=aV|	TL����!
���Zԭ7^C���-�;���X����a��<L�$>�0�a!ΰ�́euΦT+� ��PL��4,pX^z\`Z����#��M�A� Ϊ��~��^��o�� 
�}��c 	�A��e�����Paxc@�UA� 
��0.፠ ��Y\@(�gs��0���:ga��@AL��-0g�TY �� G��bh]�,��cr,�Cyh����1I?)���L��Y~b����9H���LJ;i�����M�	�$�df�=6U����I��D�ZI�"ؤg�,I��TG��=") U�#�yJ�u���&'�^ߋ�Yi���S�$�{	4"���Ҿ�N��ϕE^Ps�0�O崲�9�9ғ�a6ZӠy��J���Z��tU�G��P����?H݂E��6%EiX���ٲ�8��>�P���a$=OZmN�m��8~:����7�ߎ�a�o�!?=���҉����ͦN��)m*hI電��;a7���5������H�z��R1N�'S-�Q9�l���Q>�� ���e�1��sz=�hL��g�� �gAsSC�0L+��:gK�@RԬ��GK�e�Q�Z�@�iT��H��{#�\ON��_P6kc���t}5hR����+Ԥ��TȄMJ������&�Ø6�8�O����i���閗7[ږ��gxO:2�6���4æۈB�S�"i ��4m>H�E �c���,�L�I�ܭc�X9EY��_Lͬ���~��g��4Wm����9�=�x�nZ��GU�;H�H���-:U�a�����HO7�~���g�QFi�c�bm��\7�(���UI���f4g��Y�oXc��a�ºg��U�] ff*l��8��
�X��}��, l> ��5Җ�~�XaK������Y��j�
Bղ�ڂ��6k~wP7�т��va�h~�=,�G�l�]��Ѷ�#g�ٮ�â|���Pa�G���`���F`�uN0/P��aP�'][ ���V�������V���u���Uâ<� +T��fs�`I�b�-�\�ؼ��؄y+m�3l	Ǉ�C�����c^f�;#��:.P�y(>��t������M�xvp2�P<|EYq�7�����N���;��M<y�7���K�[R�QXx��p���Fa�a+�W��(.u�d���&�g�~�x��c���~G�Ιn}�A��4~�3z(:�U���o1����+��z�/?�Pb�8uv{�(~�{���'��׏����;�g����0����-��J��oXt����z��ɔ4��2]-S���y���h+l�at Kf�ypUaqX Xu��HFղ�����jVAAL�,.`YDqu���
b���$��ت a�8�� �*HX �"(��
�pPW$.��U�K8(��q�jPW$.�b(���@P'T�
�Y��z��0^dj�w���1n	�����*9��
[�A@AT�DU!NqQU�wKX
�k����Ƥ@At���|�I
İ�J^A��u��8K
�V!��� T�� ������}�A>Β��q��e� �D.K�>(H=���
R���n�8ӸR�,-0g���F�ø]vQ�����;��l�;����� 5DC�\K=}�T6��s��V��'u&��~ɴ@���wh��A�?)��N����	|��s���ﷷ�.�97~��*�\ᅳaSoS����/v:μ{ΰ�3��#���H���ef��t�()��2g��0� L�=Ĝ���C�xH��r��ˉ�#���U�����;}//��7�f�n;m����L��y�P]ejI�a0iW9_
χA�IL"���uq��0nO��u�ZbB &N�,�:Y��wܶ��t�5q4�L�0�DӐCc͡;�q��j���M,yam6ÎJY��&�����>��,M�!�G�2x���`��uƸ��폒�1QUkJ7����%�	��0{IL �e.�$1�F3kILO#�i��6]]ZͱA�t[V%?z_��W���}{妎��r��b�@��2'[� ?����ʍ��a[c존���)�����b8�T
��D�q��[9����C�:�Z`����E�VV�(�:�IURڊ[�a���2�(Ί�
�.k�4+�W�vV����FE��Z��I�����3�F��1\=^qD2U�7��Y_�y���se�z?���g��?俾~�I�1�O4���"���Hݺ�o6��e�ϛ1�j�������p����]eo�4}7�k������ߎ�>���'P��ޙ�-�J*<�㦲��u�l���!��φ�Շ�a�\�����`B�.�:�z�vA��*�T��Y�y��a������a=���r�B�>Vˬ �XQi'�
�뇮V����f+�U��q�Ԫ��n0`���{�ﴫ���TVT�c�U����kW��|�z����;]MVU�l�k��+�M�?GWT�b^������@V���Az#��Sz��WdU4��&J�t!��ٮ����vA�hj�7eǤϮ&+ k�]*�5�R#Bmhj%���N����a��b��E5]#�H.���?WP'�����*Z��*i�Tw��@.�Z9iD98�����V��k�/��Q��M�av�uEU`�E�����`U�c�[d݀J�����f�鐖�^MS��|/����MԱ��k� �b��([��RP5S��(H)�X���,̆uS4�{5��ο��6�񳷟��y��ۿ�(XL�u]���=�rȹ�׺��e��=$��m�Se7�����z���Ҹ�ܝY��
Xnf�]g�����^�a7L�_NO�S��kk�_ANjj�� 3�i�H��ޖ�O��u���9�x��_`!5u�\ФWEG�:��N��\j���:~f��>��ԹNk�	��Dp�&�r�s<��$V~�I�yN�Z25U�2U���f5�y`U�vv:e`�Y��gE`��r���b%�UY�CLI�Q�ҕuZŊ�4�����7�ch��\-<�[y��2�Jo���J�}�Ůs-�����B�m�dR��!1\H����QZ�I��"�Hq�g���i�X $����Aߨc�L��B�Sè��Ђ��*�����ۂ��P�c�
WW0�    �ưq�+)凳�4�G���Ù����`����{f��*��j�<�>�o�h���q�q������ka����5���:Ԍj���kaˮ�f�蚟����}�s�(&_���+�րY0"����)����{xp�{p�6Zn("��,�ɞ��n��v��cr��5b&y.Z�|�����5��� �r6���o=����[����?��������c z{o��/;쥳��j�fK�W_A�0�M��~�,4�_���ᦢ�$tԵf�����y�ï�oތ���8��ߎ_g����N�d�;}�4 ��6��bݷP���P�ޱC���&���zoP�ZE}5ƕ���8x{���ޘ	�P*_%qZ]t幸i�F?C~�y���M�_�9}�3�44~����Tz��˭�w?1�;������?��7j>Q���	���h���-��x����,_�I��3Z��3$3bF�L����7��O��Wƌ�a�������;	5K�{�������,�7~�Pz�RR���h���sF����ƿ���Wҏ�~e��~Un^�4iZlҍ���~)�.���GS���O��SK5�����1��N������T�M�o�4��J��k�7�L�bF"
5�⣺a��1��Zc�"0�bFߟ/�Gl��J�!f2P�ĉ?Q@5������_��>ƌ�8�%��1�b� fn���!fn���1f* ��W��+~n��;b�ܠ�w�<#�F�o����o���	�(������xG�(0���;J���Y��� �(P�3�:��D��[�L뉖ǌ�3c1��cF�Ƶ<fL��V �-���zx�@���(�b&D�M�D��q3Q`���w�BG���0f$���	q� f�@�8�� 3b&Č���1�0fj31�f����8z��$0�b&	h���I31���C�$��g��C�$�'B�x�q3� �$��	�gb&@�D��	3Q f�fs�1#�]��-�
�'B�X�����3s9+?����R���ja=s��i�3V@�"Č��1c�,B�8�'B�5�� 1�3������ ��rr�|"��-'g�'B�����D���;��\'��[�K�O���31�%f�3Vcmv�\�����k)�3�k)�'�D�w�"�1s�����q��)�3��)�w��w��'3cF`���x��̿)wo�H�>���'���'ޠ=�':x��{�t�����'x���=�} ������	�x�;�g:u��0����O���x&����&���0%���#���e��|"Č@�Č@OČ@���[*��!fn9�k>b�]��!fn9�m>b�ݙ�!fn�Aj>� nɅ�
�@��_����k������T �q�p>sK�|"ƌ@Ma!f� ���T)M��w�*��D�	�> +Q5C���\��� �-Ol͌�<#ЭHb����1ff�a������TrP�	|�F�@779�3=�� f���Cm&�NbF�?�<Č��
�!f���Cm&�NcF�ç>��Ϋ��'��.���qW��q=�1~������7��O �N�DY@\�1	�Ǥu+M=�y$��S�@hy�@{�{�Y������	�&�,X`�,X`� r��`�.���=)Y ��iM1���4B�� 4�wӈq`��^����(/��F��x�h��+Cg��ӕ�V�:���g����q�1tr����5�W~��]���3�|��� ��Z��h��c �������S�1IZ�:.��ߡ�gY������fK�d.���ǐM���s�l�N�է�"��"�%xn{���������6kD���s���z%�� �+7o�����ǂ���	�k���c������\{�%ަ��?���r-�\�p�?����r���r~�r��b��C�y�yob� ޔ�8��=��E�k �Ϻ���G�C�����!@vSb�0�ɍ.f7��Bv�b�8@�9�l!ڌXU!ڬ��E�&��}�C���PK1�HLs���p=g��EӺc�1��� !7:�+7�	�+VQ$^"��	Vt$����v&�B/��	r���9�ˍ�?k�\��gn��Zυ�g��r��҇�Q9��
�����[υx����s!�����z.ě�=����;(RqQ..b�%��(W��M�� �Ī�r9��?h�����s!��v]o=⍤t�\q�uGL4��郆x�ؙi=�X�i�7/�������-��/A=�o���s1���/A�)���x��7�=�q�xsbqA��r{�h=�X� ܱ�IJ�b:i �Y�|l`�����`~�_��q��z.�[��d�o7�%��\�ob�c �:t��gPOF�y�����B�%�y��ߢ��Y��(6o�ob��B�Y���\G�o������K���-��M�&��j��$�=�I1�uor�å��\���ã�1�Ŏ�(7ooQ�~���(�q����`�I��E�x.��N��Km������Kv�M����R��{��c�����;*���6���o?3�v��������ۿ~3��������U����7o?~���Q����1�,�ۿ�������w����o�w4�O{��|G��|�����ׇF� ���z�U�Y8���6��_��r���W�����\��W�ӥ��w<����{GP�S���biV�Ks=�_kF@Y�?O�>����{G�l��f���t,ȰZ+G�a�.��d�^�a������ǚ�Z�\~0��-H;wH��s�yq�\���Oǟ?�z��=z�6�׿"�yq�0�3Lv�1�M�y ]��~������?�?�x� �)KA@#�&Z��8��4��(���F���&�X�9(9LR�q��h���;n1�%,޶Y=�0�%�E�6���0����6����+�9b@!�f.0$A̤	?Ѻ�[�	�j�{�>�2hy)���1��ǘrO�u�$?9���첍ބJ���{FNց��W���RA�g�vi{+��{T�a�k�y��qr甆��l�l�8���C����[I{�ٞ�N?�x��-����i�,x��}�4���%�%98�q� �E��8Jt�"p<�*�S	8���
r41%�� ����,P�����+Qf�q[I�Y�$?_����`�_NL�g�T�������o� ��y���/��C<@�$p��@Va����@�2.|���޶8��?��wh�<C�;~���XH$�����FN���{?����O*��,�~�,Dങ�� ,8[ *�n�TE��z3~�������.��<�1��2�d����?���?x������/w���˅#Og�k���z伺ࣽ���񜼦�dZ�l��W$[ ��|{�x6l�+�A���d԰5}5lE߶�aSo�Zd԰�"4�ִ4L�i3h�^Q�,jXX���&9kXP?��T�>��L��ߓ'G ��	�~=�S@v+�5��d�Y�l�L+�-���d�ɧ,�y�0����6o�����?Y���`��w�.�Y����.NN�$�p�NW0tqJ�����������	�Ǟ��<���u�Wǂ9��9�OΩ�]���& f)��q��6?�j�8폕�'�e�3� �WDh�&Zڬ�&@�5��iM�tX� ��D����:p��$��̭�N0�k�Y,�G*[m�GAӕ�Ɲ�iB���H��95�E%�����v%��[���W�z�����q%jd�8�U�AM�֨֡&���	�ɯ�	�ɯ�	�ɯ�	�ɯ�	�ɯ�	�ɯ�	�i�rjE\K%@��:��5h�:��צ�֢P��&�P��a�,P��9^9���ս�@]'^�
9k�+�M��W�M+ͫFmZ'�z�ڴ�)��M�)��M�&���kԦu�&��n���I�6��TB�6��QsmJj�    &Ԧ���`MG+�+��N�e+���Z��6���&�5�Y)�h�Y+r`MG+����VRD���V�{�Rc@��JY݀6�Ju�AmZk�A�h%m2�M��6�&�u�=�W�t�a�K�6���f�/
"r�NK  �� �@h@�%�� �.�@YXIx-ȂZ)�Y��R����+����E��dl[W�:(Y�Ji�AɢWZb8\N����,z%v�ճ���rj-omR+i���^i9�@��Z*�)�R��Mj%o�Mj%m�Mj%m�Mj%m�Mv%m�M+ūǭ���Ƀ6��jD�ڴ�Cݴ�FD�mh�R�8"[+�8"[kC8��Z�����pD�ֆp����6�����pD�ֆp mZk�Z��Z��i�������dǵ6��%;��!-�ѯ�MВ�J�-�ѭ�àMn�xmr+�ؒ�V�WhɎ+5G��ڴ��CKv\k7Z��Z�!В�ڕ���V[�dǵv��%;��2-�q�]�-�+�J�u9u�Z"`K�J��[�WjUؒ�ҾD��l�N��%{����-�+�Jl�^iW:@Kv\iW:`K�J��[�Wڕؒ�Үt���v�������	[�Wڕ릵F���J*�-�n�ȁs��V�Z��J+ɀ-�+�$�d�5�ؒ��iC���*lɶ+)"�dە[�W�o
ؒmW�ְ%ۭ4�ؒmW�&lɶ+i�dە�	Z��J��hɎ+}��%�����e��F˕
�G-�f	ð�r�H��:+�����J��������Z���6��:k�k���k����{�|�q�|��k�k���+}���ۭ����W��%8��֚WЦ�.1��W��-@�w\�r� �1��M��W�t0@�w\�� �q��N�Ǻi�}��^��&`��J}5:��J�����b��Kty���l��[�?��j+" �n5���[Ab��K��b��VC0�Xb�, h	�n�`�E@t��J�[/2Pdp��	KDwT�X"����	KDw4�X"���N1w/��;,�s�"V��i��k-��	����"At�q� �i��Hݴ�G%�n�D\$N�DM�< ��z) b����\/2	�X �E����%ƭX �K�G,ݥ��#��Ұ�xT��d��@t�S�X �K�,G,ⴐ��5m�v�%�[+�%�А����!w�%DCX��.! *����wٱ'K���ŧ��Q�_��M[eA$��?��ǆ	�91oq Q�%6�!�'Of�c����p�o�4����8�������h ɨ�k@�DD@2��5 ��1�
�����="~��]#Fw���-0�k��.�5bt���%bt��1���E���9"b\TT�+b֫��Wĸ��5���� ��3��1�G�U`t��)	f��״���{D����8wG=4��xQ����1%5V�OT���#�����"�^���!�=������ct����1�{����=btwV���stG������9w�\GwH��#^F�����F�,!ۏ6K������8`����l��U\��J��6BVIt�"��EW-��]�af�UyCW-B�Yt�"��EW-B�Yt�"��EW-B�Yp�F�0��E3���
��6B��j#B<^p�f���?��D-~�%�*nT�o��D�U�#�/�k3¨^�/�s���h��U`���zm�����[�����!��0�F�n�`���l�h�ق�6BTm!��������=`t����mm#B7�0�f�A��mD���0�F�V�a���f�hZ͆�6"���mDh5Fۈ�j6����lm#����6"���mD��Fۈ�jv���-0�#���mDh5Fۈ�j6��qfw�h�6��qbf�h'f6��qbf�h'f6���'om#��.��r�{��
m#B��0�F�V�a���fW��#
Nm#B��4�"�'om#B��0�F�ɀ�mDh5Fۈ8B�a���f�hZ͆�6"���mDh5Fۈ�jv�;bt7V���qtG�0�F������!��$����>t��K?�ƾ�HG�W� �=4����Q�9$�!�GDtD�����1Q"""rD�FD
���{�;""�#��S��Q?����~F\|ȽÀO~`���?0�SĀ�)b��1��>�>��2R���q;W��������ta�EJ�H�(;���IJ�x`������ԅa�#��y,b$.�GL2x�S�B=�9�����_�2�?���i�*}��_���'����y���_~���/���/��g?�Q���"p�B�;v=�6���Z���ϩI"���D�:'��٠s�����-)OSM	ۗ�=8�HJ5u��sjV�TS���
6e�r�)�MUaSM	l�
�jJ`SU�TS��¦��T%6e��Jl��c�ؔ��*��L6Y�`S����l*I��T��[�`S�8���&q8�MM�p����65��lj�ؔ��S�&��uS��6��MYbS��Ħ6e�Ml��*ؔ%6U��$6U�I��l�R�l�VSR%JԉT�u!բ�F�D���*Q�e�J�h��xm|Si]kõJk�6�Zk`���j`���j`���j`����`����`����`�UK�Ti�v��J��T7u�iY�`Ӕ����)��MS"� ��DD��yJD`Ӕ�8��)q�M��t��MR�6��a��MCb� ���&H�yHl����Ħ	6�Ml�&�4$6M��z�?�&�Z�}���H�N""��l�JO��ڕ^`��+��&kWz�M֮��,�h�M�˵�&���"��T��z;��&��<R�&���i�M��	C;[���,�^x��&x�9Il�n�r�ϖ���&���^�ۛk��M�ݚ�g�n���s���/<Kvk��%�5'��gx�Y�[s"���6U��9�=��
6���Eb��\$6��Eb��\$6��Eb��\$6��ũs&��T�M��߽�{�����^�[�Ħw/�-U�����T��o�V�����.tb�,���ZO�D�5r�&�`�dA�
6Id�g6u�
�`���+�$��
6I�v�`�dA�
6Id�`�dA�
6Id�`�dA�6Idn��$27�I� 3�p�]sng6u�-R��$�(7�M�ӄ5��+��o���·Dz�[�?��-џ^���&x���3�������N���o���·���MKb��%�ip�I��Ħ��ɪ%�K��2�p��h��~�5�w���<����<���l�<�����<�&ɂ�k:���l���̮Ēɛ'���=t%�ڵ�MV*ش%JL�I:Ǒ'�$���l��q�6I�8���S�y�M��:�iI]���^�����d�,�I"���ݐ6Y�!;a����6Y�!�l��l�vC6�&k7d�k���ݐ6Y�ڃ.���O?>�F����� p��㛛���/�|������-�~�[�������_�����+����)��ߣoY�������tsM�q{�b������~��^~y�G���������������/���Oo��_����?���?�?ʿ���������?��3܏���FV)N�[ҙ]:�S���ɒR�z���T�wͬR�z�d�D�ӔR�z��T�^(o�%��d��Hk�d�S/�6Ifr��ݥ7E��ԑ�����i�B[��R`a�$����g����Z�R��B[�3VhaK}�
-l��X��=�����g��RW�B[�3VhaK�K�Md=M���T|9@{��� i���;w��ʂ��I�?J×$��;w�j	t�NV-�`:Z��s'����m��Ν�=�;Y�D#��T�ɪ%`a'������Zv�ފZ���v�vhaK�K��ƹTK<X��x�$�t�I���Ν�v�l�2�&i΁����_v���X�I�oS�'ݹo��sRY7Y�l��۔�5���;w���v�쿂��ɚ_'�$�ݹ�d�X�I��
�s'��+�Ν�}Dt�N��WН;I^Y�o�j	t�N�#\�$q�n��ễ�o    �=:�ƝM�n����V����Џ����\�3r���xz�<]��.��3�9�^�<=c�2v	���+�������3��7O5乺{�oױZLF=e��*zzF;e��q�%f|�1�B2��|����8�����8�+�7��<��}�~zF>g�����\�Tql�	�<Ep���8�A�����5��y�w7yz�y��s�!sT��q�j�u��8�5���q^J̽�|�C�`>������8��N�O�8��c2����{u�}�<��q^W��Q~󐚡��y�1sT�,�q^ZH�P���̈́z���|����W�q>C�j��<f�-�q�B�εb��^��8����#���|��>������g�b��������X��A��1�h;��S'6��R�4��E��v�+�Nl�q�r��ho����s�~{m!�G����y����񛇰�'�=���X���{�1����q�)��_(?�5�z{V�Bڳ߂ջO���!������^#k�����o�c��]ڑڿ9V��M>j��Ƹ��~���S��8������~�~<�ϯӟ���7g���x�O{����ho�����`§�ٻ�������*&W$71�!����CLH�b�D��Ƴ�lo$���$��g{�aM|�'��g{�aM|�'��d2l��`X3���f��W��QN�Xn�݂d���%�~O���x(����[L�ދ�����W��b2nڎ�)�YQ113*�!fD�t�����%��9*f�jjT̙��=Wu�6)
�(tnP`G=�Q�f�;����g����ݢb&�g�Հ%lܠ(A㦥���q�RFL�#�RAL��l�"&hx��4ߴ�1n�괖�&,�*[b-D��@�E�
�(
dP�FQ �5��Q�5t�Հ%j�d��nV��~�~�?��"ow'�'����}�c���;���OnM�n�@O�-����<b�������.�P~$���.V~$'1�"����CL�x�Gԃ<0R�y��V1�t2�7���X��� ��P��b��`��������Vr�x6�����Q�
@孨�1;*f�cV������p#J�����S���U#���<��9�E<�1UG�հ����11��k�Q��>i�`���:��{L~��K�g��wg�-���M@�][}��$11-*� &극���)Q1OZ�#�����q��=,fⷩ�m�'�Y:�p/"�D��bF�S��b@���6@���y5��oo���{ϻѾ�b��~�<���9���)&w$/1y y������1+y!�����K�9��߹��ל��knb2f��d��lO2�����l>�d�8WM2L�1&&�+⌱�0�$�bM�^��\���{r/�������CJ�HNb����b�D�������<����������rN.��dX��0���`ؽҗ���,�d�a⌱��l�m0,{�vOd�G�ۗ���^M������u����z.������sq-��6x���U䏈��#""ZD�DD��X�(9 �D����]Z^���������ƻ|�ڝ�z}��B�t;���	��-�މ+N�:�v�7����Ć�m����<HDj��- Rw��"u�7�zqBA�^�PiN'D���V@�)�^�9� Rw�TI$�7� �p�TA����H�!R��3d*�T�b��HEzzA�"�D*��T"5�85R��C��I�MA�����HK�MA�%=� Ғ~Si9Dj �r��A���2DZΐ� �r*��}$�F��D�ip(�Ԝqڹ�$��\�9p� Җ�)��"i;�w�H�yz����t�H۩ƹF��]%���9D Rs�?@��i�H�o:A����D���\�IW
"����`p�]���ɝmi��]�� �HÙ�'�4�re�HNa�@��iqgۙ��T��"5D�T�.�:����C�ŷ��6�T8lI�踫����xȸc���W�j�Ck���S+R��ڐZ�Ԏ�.��f)u�R��ͭ��p�CJ��k���Owu�#uJ��|��Ԃk�R*�d]+�d=Md�u����Pb��T��#�Mә�F"��9g�JH�pθV��u�ŦL6I#'��4�u�`�t����lZźè����p���
6�uS�f�6�2uS��_*R%��Ti~-s����MRS�&��MYbS��Ħ
6e�Ml��3\��,���MYbS��4r*ؔ����MYbS��u�`S�R�������&�Z�t��Ը�$U�lj�L���&�tlj�L���&�tlj�L���j���Il�`S�����&��65�Ml��:�T%6u��Jl�`S��Թ�����&�
�g6��`S��u�=�U��[{�{����{:k�``/��!xOg����v��Y;lJR3���!�`��S;��,�i�MIb���Ħ	6%�MlJ�&ؔ$6M�)Il������&+l�V�l�V�l�V�l�V�l�V�l�V�l�V�l�V�l�V�l�޿n�I���[oV�[�p˃�ny0��-^��<z�/|H̄~�T�ɩ�fb��<M�^�tFΤ>�k�{錜���[#�^���I/\zc6�K�!�^x��^��޿Nz�˩�&�p���>$�`��|�	/|HnȄ>$�h���33��$��Y�(Q�&�Z��-=���g�R��-Q^��ᅏ-�^��Re
/|lk��M[���ǖ�&x�C:�5+�$�_ᅏe��M˺�`Ӓ�/|,�M��ǒ�/|,�M��ǒ�/|,�M�}�ߵ�MR=/�K�'��n��»��w��3�w�ћ�»��/�K̄�%f�6�wɃ��»dNx�]�`&��n�^��8�w�-R��$�	^x�v��w�\��»��Mx��z
/�[�$�w�Ҙ�»�Mx�]�4&��.Y^x�,�	/�K�Ƅ�%~�1�wk�^x��	/�K.ׄ�%[n���Y�9����4����/�Kg�&��.d^x�z��E6I�+��.u*��»��m��R/�	/�K}/'��.����»��t�/�K��'��n���»�/|��R��	/�K��'��.u���o����>��0�p�Z�&���ޥ��+�M����&�Z�&��X���J,x�]2��.�^x�̅/�K���%sa���{�/�K��%/|��ߴ��wi~]�k:�M�k:�M�»ti��U��/�z��/\ڗX�n�t�n�t�n=M�n�t�U��_�5ӱ_�U��_�5ӱ_�U��_�5ӱ_�5ӱ_�5ӱ_�����/\ڽ\�n�8�/\z۰�/ܪ��/<Ilb�pɂ\�.�F�q�I��w���b�p��\�.����%�s�_����~���/\9g6m��\�.���¥����¥s���%�j�_���^���6�_����K�
��.�!X�¥~�^��_b��zi,z�RߐE/\���K��p�w�.u+Y�¥�7�^��Eu�_���&�&�w�.u�]�¥���^��1v��:�.z�R�/|I.ׂ�,�^���l�_�g��K]���^�Dx�K����%��^����/|I&��%J����D/�9\�Il�ޥ�/|I���d��az�]��^x�I��^>\��_���-��#%�s�W����������_���˯��_�R�,��2x���^��o��2<�m�G��%�i���{���,����z�� �4>7��-9;�==����{�5چ罥Js����|��yoi��yo���𼷴�����lx�[Z{ox�[2�v&��9����)��gq7�Ew߽�9%h���o�J'�7<�-��v!{�g��vj���}�o}����{������OK鸖��<��|Z�D�JYHA))AU�W}Oy$��R2�%��k��7�OK���A)���ȧ�`�?vIzZ
��c���`�?v�{Z
�~���A��0��j������%�i)��/c����R8��f�Ʊ��s���c��_{Z
��c]����G�Y)�c?�w��    ��*���y?����ۊ1ꎱ�"����v-Q��@Jԓ<�4���N�U��r���/wZ�y�r���/wJo7��)�q�^�}7ʺ���e�F·�{�V��H���>��{������q7�~��S�㧥p�T�M�Q���(Au�$K$Zã�����vK];6<�-u(��h�ԍeO�!�x�[:���n�W�^�s��	�z��E6I��"����N�nx�[:i���n�T�G�������$��u�������g_#�W�?��IG�_�����}��?�����ۗ?;���Z�$���_�FQ�O�x�̕]m��Z�ll�<DzV�F�V:x�)�J@7�Z�ЦP+��j���(�*�ˍHU |D�s�v=R�"�Cjs�Q`�s`�����sG��<:��&��69G�Z�p�4X8R�ؔ��7����-��7��`:�������o��������x�����?�}��UKG6�%�Ց����n��S�R�xğ˦�^{�xi����9Uۑ����|Z�ĳ[�g�U�4�븹�.o~ӳ��+.��~_Fj{��`QPD9߯<R�9��V瑊]'��đڑ*M�oל�!G*ޮ9�Q��L��@)�|c�%�Z�ξ������;�#�����#���w;GjC�D(�Z�N��#�����y�<���G*�$����~���A���|��H���XG*xηn�TlA9ߺ=R��%6���픥��-(��G*����c��%6����&Et*z-�N�;�`�5r:�&��nr:������ɢDG�dQ���E	:�%�t[����|u�H���N��=�#�l�8�^�ӱɎT���Fő
69zȑ
69ߨ8R��d���~�Ħ��&�M�k:�M�<s�H�K�H%�����8�G*�t֜3�&�cMg�_��c�8�[q�M�m�ա#n��B��m���#�|=�H�u��T�7=v�K��u���Q���������T��T�-�j�s��H���qG*�䜘=R�&��
69'��T��9�t��l��f��UZ��ĺ�J��$�82Uqi�)S�V����ߔ��Ko2Uqi�)S���r:�隴ߔ3�&i�)g��~S�d�S��S2Rr��)�7�Sr~r��))9���f���&�;���͒��t�h�Kd�.Y��v�dAf��V^�Xw�l���{w�׃I�G�th&te����n��+�=%��O�]��)!��Z���|O	��rű��o��ѕy������i))!}[���|O	���2�h�?˕�4�¨��W9Z�Q9����h-I�W�b�����x�d�hd=-�cm����[Y�&��R�?��|Z
��>�OKA���'�i)��̣����d|������������[JP�0X�=c�I�7#���k	����۵D��D�.)Ac`e�#5O̷oZ�X��|��H�4�'�~м?1�c�Mp���s��w��x<���k��+���t�$+í�����uJV�[7%+í�����Ur�2ܺ)9Xnݴ��í������M�+�G*�$9Xnݔ��d�uSr���$+í������M���p��`e�uSr�2ܺ�|�He�$�n��شy�S��6�&��uSjaY��|��H�����`���#�k8��n�||��ʺ�!bI|e�W~;�!bA���v7*5�MN�V2�$��*h�:���T�Ij�]2{`Hl�`���d�Ij8^2�$50.�k:k��MN��V
��| �H%��Z��M·�T~#5f߾��zz�,ʟ{y%��O~�J���~jg�J�B�^�\�݈��5q!�V��4�+���z�z%� �S/[��V�~����3���>�y%���bA��}�J,(����WbA�����XP�q�2,-W��Fm\,(��+J=n��łR���bA�Ǘ+q������#���w%���x/.���x�&.v#֚��{5=������m�	�W�㉸�؊XkB���x�1.�#֚�:K)�I&��	���z|�J=��E��x�<.���1��X�Rɢ���
q�\�Y�B+���#.����d4c͏MO�bQK=v��ł�sG�.�N.�,8�!�'�b\�����łR�;H|%�����+������XP�sg��ĂR�;�|%���N�^�%��X��<Wq%�zT��bA�G*.�z���bA���,q�@ҁ���Z:���VWb1|>w�J,���းX�Ǔq�>��>�b1���Wb1���Wb1�?�^��冉�F����\ZTlM��'�&RJ*�*d����9.��\��+�����_��>w��J,(����WbA�ϝ=�J}�0��XP�s��/�Bz��q�+��0�(�YKiW��O֛�
�9=�����'K1�P����T���RL*��d)&�s��
�9Y�I���,ŤB�N��[(e�Jt���
':Y��
':Y��
':Y��
':Y��
':Y��
':Y��
':Y��
':i���Zʢ��d�X�p�����
%�J'�*��*}��B���9�
:%k���,��N�_R�C'�/����FBY�L���:>Q!D'm�B�e8V��'3*}h�D[�m�h����m�>�u��҇�N�U��։�J�:>Q�C'K�������b�gy�>��yT�Ж�Q�C�Ǐ�łR���bA���łR�2M\,(5��o���n2)eM|��-�NӢ|�4-J��NӢ|�4-J��N�@���,J��N�H����U	�RQ+/����q��R���x �*�C'M��4�:t�$��I�x�Q;i�b)e�{詝4��y�$���5�`�'�J�\�Y��u��m�y�N�UX��:�Va�'�D[�u��m�y�N����E�MJI�y�u��C*-�R։��H��m����nX�QE��t�r^��k7�E��x�p^�Ϧ7��E�D|�n^��D��6/�{�ټH0o�l�R+��ٯh0��c���T��NX*���',r�c��TxIb$��h)E��1���RXjF�4^a���7Ma�`�cW��T�I��m�ˋ����H��i�ˋ�y���H�mP������T��E�T_�X^߾���n�:Y�ʺIz�+�$�9��룲�
6=ZIa�`��{��T���{X*����=*Nyy|���5��&���{X*�$Uk��M����2�M^��p��5�DD���ǆ\�*}X�A%��G�L�*}0�A$����<�*}�A#��G�,�*}��A"���R����a�`�����Joȫ����J�tk�ǫ���{�J��k�ǫ�Y�w�J�`l�u��&�����yX*�$}���K��{���
k�֙�I�O9���M���R���3�a�`��ǰT���cX*�d=�d�4�L�K#�x}��
6=��K�[����M����R���Fja�\�Il�'~kE�rM'�ð��c��T�M�ͣR���
�򨈇��!���%����Ųo���$�vx����Ųo��˾aCr�Z�l�R��W� ;�pi���i���K��N/\Z5wz�Ҫ���V͝^��j��¥Us�.Uk�^������d�wx�Y�o:��,�7=��N��gɾ��	�9^x��/<K�M��%���M�3L/\:=��K;z^x���/<K��:��,����³t�����)�^����/<K��z%��z�r�Ib��,Y��^��
��/���KL�.y0�^���tz���KL�.y0�^���tz��[�N/\j���Kd�^�!tx�E��n�^��&x�Kl�^�M]b����v',lz���>N���Qmh:����-�b'I5ꝇ}�"bx���1�H�M�^$��C/�~�!�I��Ë��t��E�o:��"�7}pQg��I:��u� ��_�^�c|bx���u��E:��!��_�^�c|}rQ'�i�n���I��Je�d���Ԭ�bx��t����o �7K��ޤF?bx��u��Mj��!�7I��Û��1�I�G:��f��Û�	1�YNÛ��1�Y�Û�i
1�Y�Û�1�Y��&��u��&Izbx��đ�&I5Û�:@o�B6 �7I�    Û���M� ��&)�#�MV*��px@oґ�1�vh�I���gbx��%��&��k:�i���Wbx�����Mz:2�$]+��&�Û��7 �7�-Ҁޤ7fbx����Mz: �7��^�U�(d�4�BO���QJʀޤ׃�N�+7åi��p�'��M:�:`�7�,�ޤ��fx�΢��Mry��&�F��M�x��$G{�o��>`�7ɽ0Ût�`�oҙ�3�I�G��&��0Ût.h4�I�0Û$s��MRy��&�0fx���3�I�Ӏ�$�k@o��6 �7I�Û$$��'�Z�$���1\z;�1�zy1|k���31|[�B!�7�t���Zbx�zv�:Lv��0;�[�¤D �M�.��ë�i�c�ŦI6Y׊�p�iBW^�ZQ7I�C�p�Kʠ.u�å~��ånU�å>�bx�zv�~W�ɺV�M��J6I�0��i)díZbx����&��.}�x@���< �Wk�
1�Z$�p�g�^��mbx��{̈́5�t�kB���8!�W�ׄ^%6�D6Y�`�tu&
N�nȄ^��^bx��{M��U:�53�䬚'�p�bx��T��5��
6IU�|�%6A��,=!�W���̬����bx�f:���t&�p�:�b��c�Mֵ�M�I:�4)�K`�]��\��'�}Vo��-�<?u#�;�w/�#uH���z��Ԃk�RjE�R�p�R;�uK�ך�ԉk�R*�d���K���&�wm`S���6ui�i`S�����.q��M�z��lz�扐
6uiVo`S�*�ƺI��z��*��~f�ۗV�ԂTi��`S���N6Y��q���	l���H�f���jQb���:�&i~`Ӓ����iJ#gT\���ѐ*�i�MK�k�%�ׁ�iJ��@�4-J�n�%&�tS�L'��$6M�M˺V�MV*�b=MX��Z��b=M`S�f�	6i��`S�f�6i�[`S�f���)K�u�M�L���j�a�)K�u�MY�l��x��5^��,=Mk�-�tk:k/|�MI����u�`S�R��j��M�9`S��lj�365gV_	uSsش��T�+�M͙�W��3��65gV_�k:g�65�M+qM�i%��Zwl��2�T%6e��Jl�`S�ؔ��*�)sM'�)�nrV+�n�RY7Y�xOg�)�=�T���5�U���j�`/ܪ�
��Y�Z�{:�Z+xOgUk�E�����$Uk�³Ex�٪���g�Z���j^x��5x�٪���g�Z���j^x��6,x�YrjWe�$]+��,9�^��IT!�{���
C;K�G�,�Y4���9�v��"-�Y:��`hg�dۢ�-��/�ҩ�EC[z��`hg�|΂��%��ЖNʬ6ui��Ж�q,��	�EC[:ٶhhK�m��[0��t�z�ж�&ڒU�hhK�炡���9�v���C;KVՂ��%�j��ΒU�`hgɪZ4�����l�j	�Y�L�$6���Ib�$6���Ib�$6���Ib�$���S��`h�-�	�v���C;K���,�YY�o̬k��3+�v�ά,�ҙ�EC[:��6O�ID����әks/\"���J��әksMg��`Ӕ�C;K]h6�,�[�	l��r�Į�̆ɛ���&o��`6L�*��0y��qg��R����J�6L�*uz�0y��/�a�Vi��0y�4�o��U�C�3�d��MR���J��&o�v�7L�*�Jo��Uڕ�0y��+�a�Vi7d��Ү��[��t&o�v�7L�*��0y�U�䭒˵a�V���0y��rm��Ur�6L�*�\&o����J.׆�[%�uW�M����&i���ޘm��U����J=>7��*�3�����w��Rw��J]T7��*uQݍl�j���&�M�����yw���4�a�M��i�N�s�;��g�:g�ۜ�ҿϵ#��7�����RgzM�ɏsJ?�n��D|_���6I����?y���?���H����6���,��>��,;�8{�G�Z���;�p�'�~;gَT��9S|�b�8]�T��9S|��v���N�S��f��Rw��קp�H�*�aGXbv��c ��;��	��s�]�#���4r��?gO�H����G*���	�`��'p��MΞ����XΞ����CHl�7��=�#����&~�ϱz����]�#��DD��:���T�8�s�G**��ڑ���a�HŊ��v�bo��v�bo����f�kG*��8���T�W��@����G*ƫc����؄~�1��T�����:'�z����?RA	��?RQK8���J6IDę��t�8R�eHD�9��%"�mu����N�#���D���_""�V��Α���1�1��O�/�@_C_���/o��!�[��Z~M�mC��-d��|�)?���w�W�?��oW�W/��w_�����_����_����~Cn?�������sΗ�b��7^שo��' �"�r�����w�w��:�O�HoOg}��Y�}l>R���:��ѭ����~ˣ\�������}������o�ݳ��9�u23��m>���񯯎����b�W�W;�!����ݎ�v�D���I=;�^����m�,P/��Y�^���@�lcg�z��������e;��v��@�b�z��s�~��o��zx=1�zؠk��A�n?�t�3�Aע_�]Sy���xе�S�]�]Wlе��k��=���߾&P��e����9^.kj��~��^��Sj�&�55�zM^M��uyƫ	��2�j��L���hS/s�P^���;�Գ��I=����x�m�w�?���?rMQ��~�ǷK�-4k����Ь�늽�׵C�6�+����
��%#k�f������-��6���C��&��v|C|��;�?�����b�/�g;~#�����H�ێ����q3������=�+��m�VP/�ة�^��7����ǃzٞ�+���	w��K9�MA2zm��#{��|��6���W�|{bo����:�풶��sK]����oOmm#�xԛ��뤞�������޴���M;ԛ6v:�7����z��N'���M����R����Wv��yٜ�,�C��U\N��U��B�@��,}Yi�d�A_Vv!Y N�}otɯ����／�~Tn��~�i���1������S_2����9��rμ��Ϭ�Ρd6d:�ّ̢ٔ́dNd&%jN&8ԕ�EU%j
�8Ԕ�v�C͹��PS������o�CMa���2.p�(����������C�
�6�!�C�
�68�mr�y�����[ph*��Pr�
8����8��߳%p(c�%p(svK�P2����d�����dp�%p(svK�P6�+-�r2���p(�CEy�28�ep(+��PV8����p(�CYaB��Q'�g|�CJ�������B)㳀CE�*��,�2V�;��W'�~�t�J���<���s���<��JmR2���SfNJ�Y��:�Z��̟
*84����CC�P��¡J9�'8�ڹ�K+-c�T���!g���!g���!�Ck�2g7p�Y�6rȹ�������!�}���'��!g���!g���C۹��~��N��Og�Ld*L��Jm�72��C�s;22��vd*�ɨ�
�FC���A)����^��V8�:;�`��C�uN�C�'�!g�L�C&�!�}�����u�3�MrH��'�eNm2�!�ނCN���!e.[��R8��8{���¡9�\9�0aaH�5������Cʹ���!�C���rޡmpH9��6�!�Cۨ���m�C�y���!�C����p�)�����^m�C�y���!�kO��0�m�Oݍ���SO�C=q]��[ph�'ph:�-8���	��sKuB��PW��u�ʨ��1g��z�a_���=�CJ����!'R�#�)�q�����)�q/��}�Է?��k�B�ѹNph*�}������R�Ч�J�@�z*�O���������v�,�J9�����ӧV�u��J��N�Z�W��S+=�:}j��{��_Ǌ���7rH�=?|�    ;�L�˔3�>�r��ӧV��w��J/�N�Z9���S+�{�{{���cT��s����;ι*�[�اv�ױO��`�㼽�u�������9���S;�?;|j��g�O�8.�>��.�O�Ԛ���ӧVίt�����N�Z9K��S+��:}j��g�O��/�R�l������>�!�ޢ?uVΗu���J�>�!g�����Yҧv֟�O����>�r洳?�����w��O��C_�Rz�w�Ԋ7�ٟ��0؟���؟Z���ٟZ���ٟZ���ٟZ���ٟZ���ٟz(�
�S+�):�S+g�:�S;~�S+�:�S+�";�S+�:�S+�:�S+��`j���H�����Ԋ�3|j������d�?�����V����Ԋ'5؟Z9+=؟Zq�G����F�O��33#cH���Sg���O����@ꬬ��Sg���O��=����٩П:+� F!���Y�!e|�?uV������y�Q�!��(���'5
8�8������9k�)k�Q�!�ΨX�)�樬��Wp�Y�U�C
�*8�+9��+rւ�r~OrH�-�S;�&���+z4pH�oG��s��Cʹ���!�\�h��r�c4p�8�R�A�Z9�<�Sg���O��s:��Cν��sˣ�R�'�S+��|�|�h�?��m�?��M�A�Z��5�S+��}j���O��$����`�>��cnЧVz���J��A�Z�8�S+��}j���O��A�������S����gk�빫����y܂[�O~�S��c�)��*�JlC�b;b�;α���;q�Ê]�՞��&��<�Sl�b3b�[k=ɫ�.VC���k��5k�q�Rي���H�)5�5nwB�u�7(�,8n�R�T�+n����d�Rق��Z��ؠT�)e1y����4j�,��3�RY�3���Ҹ�	+�,�@3a�W��q&P�b�LX�Y��	���oJu	�3�R�z�2(դ�of�RR�z��:�dk*ȠT�bA�.ͷ3�Rָͤ�5n�D	�����qeU0���on�=/���O^~��/�:���,5KX��
�d���%޲��(k�nDY�p#J{����'y"֚`�B�6�X<Y�&\�U׌'�ZkURJ���E�
J-�R�Ӱ(UQ<u�R�K<�R���j���5ۼ��k5[K�/���9��sed^�)ȹ0/�T�\{s����bNG΅�u1g྅�E���\�s���2�_�!��[慉�bx0�x���ƃ��C�J�<�Uyt��B�~�W�׋9�-�r�c��Z%M?��\qY�����"l�`�I�bXr�����"��-���s��q�V��c>�0��W6�.�ԈN(5�l]˙�Õ���9\z����x�ˁm�m`�\��[��<�U��\��
�����\��
�塽t��\��H�\����<�KJY%5�塉 0��&��\���ۢ�塉 4�5�����łR�km����>��bA�+۞�����|.���)��XP�ʻ��łRÚ�`.�+;������*X���&��@�)M|+���(�`.�!Qj%��$J���D�s�Xق�<����\�R�Z�/���R��宍[��]�0��6na.wm��\���v�\���s�[E͂�ܭ��ʠ�uvfAd�����[g�D�n�y[��u�mAd�֋�UH)-���&>���R{D�n�z"s���UXKY�D�n��"s�����kM���ze� 2w�����5�Bd��.ܪ��,JAd��.ܪ����m����)e�JY��V;S�Y��Vk��P눵p�b-8��X�rl���gk5����A)������KJYS��n��[P��Մpu�RV���QKY}-��nu�\�����~�T��������KYS�`��&��G���@-��P�����h���vj���ZE� ���o&�Zh����h�kv�ZE�������E)�������7m��]��v�8W��E�b1�]��U]�kv��̮��b2��Z�{>�]8��Zp�{>��-�fW�&󨮆P�ZO�fK5뷅{>����Sۗ�{^�U��=��e�|j���m��=�Z��|j�o�Ok�f�=����N����v�=�����5�:,�M��%����N����%��XP�zE��OK&ݙ���Z�z��k?y�=־Ԇ{>�q��PE�mA)K���m�'o���ڴ�pχ�չ��̆{>�M��|X�ɦ{n95��em��Ӓ[6�s��p�k�n2)%�o7�sm��\�Yp����/�����5n�k�s�j�Ac2��ppχ�d����K��tϽXRJ�ɤ�5�5RJ�e-eͷ螜ºu���J9J�}����|zMy�뗿����>b���z��_sm�q��˿|��Yhy���kB;�+��/�[�&s�-�J��9�-�Nuo����<�����W���9h{�-�������Jα(G{�+~�����n��� ����\y+v1�ݙ�sI�����W��oe|�o�N_���{����������<��;����y���ib�s�O��?�r����ޏ~�M���ڎ���]ۯ�=~��>�2q�q�9��۸�����a���i��<\y�~m8傫Ya���o�k�WkY`Dqu&CM=.d��������|��b/��7/��q����/^���o_����?R����,?T(�ģƸ��\�1�t9��S��]��r�H���ɑ�EGXqV*�aESi�	Z�99aESx�2q=q������l\O���	���:rȃ�ߧb'�Gx�i�#<���ϑD}���!ªˊM�+���a|��1��/����c^9�|1��+n��n���7>oa|���X�s�]�ȯ���)�y��S�gR�ԣWӋ9�&l���2"�5~��x7�Y�?OE����x}
���G���G��٠yz��xE�n�ݚr��f\PFЈ*�qAAqOݭ��)��u<ށA$C�r�� 2��q2��q4A�w�&�0��	2�v1
r�o2��[2���d�qP� ���@���q5��[�k̗������Y�|�sŕa����~��_�
��H|ϕ��������"����� �ɘѿl��v�z���Rr��Z��+��Š��+��Y��>�)���)����R
~ӟÍ�a�w�d7G~���� 0h��O��f���n���˙���1ޒ�%ؑ��[l�|F�Bl�b7n�vb������d�f�f+��o��|W��Ίz�?��b}�پ;P�y��]�.��c˗�V���F�<�NmĜ���_�0b����:�؜k=R9#�z�2�d=R�"ւpn��'9w\�TN���I{�'��[����~[PjY�*�Բ~�J-�R���
(�-JRJZ�Jm�R���pQ@���[RJ�m�iP���kˀ��9W���9˚@��Sp=���9\���4�\X�]��x�➃q��|��s��-���w�/o�/�Y�o	���_��FZ�=%� '��j�E�h��h�@�+����"�ݷ��K��9�/��<m#ւa�~�����/��<���)�Z�taH��!_[�������D�q�����7�����CX]?P䰙z�"�2�/�"��u1x�au�x��o��n�c�c�2pua��c�j�؍X�3!�zC93b�'y�Z�L�"��1��V�4I)�4��T�
�9k�q�Rݢ�<S*i�(լ��@�i�b�R�����v����˶@�fM|�����J]YX~.���n2j�fM���&�Ju�����6(�-Jm�R�oKJY��gJ�IƊϻ�3����+����Xi��)��XiܖT+U�%U�JL.�!V��J���KJi��D�TK��ZjJ�*	�Դ(�QKM�R������A)k��3��w�QKY�~ɨ���ۂRV�X2(e�)���ǌZ�ڴ/����M.���i_
)eᢠ��6�KA-emڗ�Z�ڴ/��6�K!����7~[hj7��Q�w���j�،X�}���b����U~�����.�c��f�	S�E�8a�������
J]�J>��Z� �  �R����uԳ�s-��#c��RV-�H)�In<o-���[SA�/e������Ji�yg-e�ێZJ+�;V|V���K���j���5uP�z�T:k)�R��^?uPJ{��I)���}��-4GF�5nj)��r�=�z��p�-J�=OVo���X`ʘ�Zm������=O��X&)e=R����[��I{�J��j�W&(e��)pϓմ�LR����Mpϋ7��{n ��E{I��hL^�����yѦ����V�'�j�l���Ѵ,4���B��e~���/oǽrb�7����۫���e�칢��ƿ�C��w�|���g��h�����\���=�_~}6� ��G�X������������ǌ�ݙ�H��II+0�������~No���O&}�W,��}Oj�iI��=��S��:��y�6��w���t�U?�F`8����|7	�-0	�S3(	���J�M؂����*�]֠$0bD�\0b��F���[������ȈF��%��6�0�SX�:x�5��6���]��oc���g#���#���#�G^F~�#�r��=p.��@|�+8P��
*�����5�:�dD���������j�Xm�B$]#��*��=׷���ڽ�%�8ȑ�8����������۝��g��:�f�����ȯ��@g=�1s�ۯ_������z�mGr������"��s���;F�<��w�؅�e�n�N)v$�+6#�z�GAl�b+b�4b�J��&#����� ��6nA���[P�XW;A�e���N��Z�Xh�R��F,(5��v�R����ړJMk�NPjZ����6nA�iͷ��.j�iͷ��Ү�Z�ՂR�@�Ry��v�����JUk�[�TѮ���5�mP�X3���5lP�XS����J���
�= Gk��Xmܲ��n���J�h)a�%=�-e\�D��
b%J�T+Q���X����G�K���'Y�TK��ZZ����-m�Z�ʤ�T���})�R� ֢TF-��q�I)�I��T}�ڷ��?�ߔ�'A�Q�<��C2&2FH�BF�ȸ�3����kI}{��ˏ��U�����o~Zs�٥���_�"�="�(��L-"�"bDD�[����9�H}�����~��_�뫺�GD���������_������=+u;      �   �  x��V�n�F][_1���&)ڟ���E�(��h�Ra!��.� i��JɢD�"�3��/�9�^Rr��>6`����8��{���G,�&�u,�4���o�/˔��!\���4�^�7i��8b�oS|�y���1��t��i��i���.R���G�X�C�ƴ���i���[v8��.���yָ瞆�z��*�Ni��Nӝa��,�탏������l��wϵA�w�P8�"F���-��=W���M�A.����V��v���:�L3|bh?*���yXn���{�����e���`��x�G�D/�0#��-������9�	+٨ux�dn	A ��" H2G8n�a��ų�/F�/�;SN���L��Ϗ�ߏ^|��gm�om]��׏L6݁ǩ�̬ɫqH�I+�a�x8�Ţ�T�dx4?I�Q�u�l)�k���Vㄆ��ޝs��@޵Yod���G� Ǵ�l��Lz�����taV��^`v%��F	�
u4	>�_��3S��'x��#�sf����ʇkȢc^⺓�&�]�@K���R1&ѷ����!���3�$=���]@��)�$�A�۠%���t���gdb��aQ�T{i�(I�UE��MP����T��`Ց) pQ���1����2%��>A(I�rGH�a��+�]P�5ɩu�1���YH�p�ei�_:d��es�.X��NP�$��R�����d}Ѯ$=n���"×�ՉlHP�Z��bћͭ|!�j�$o�iw��Ø
���r�e�,�Fl���U/�2��F)������F�{I
/lO־YR��,vv �D+4`%�s����Y~)�5xrk�ӡ�����৛'�3��?�Ԡ���~c���(�ǵjg���ǁz�HX�LvЗ�ӊ7&9"	�����J�oP�(sk�h�a���sT'i�)2rر�����N�����ygchP���>�S����k�J����c����6�3�#�i}-��[��/
`�)]�T9o��Ag,S<L%,��k������O�˷C��_}F!8�ʵ�Q�e�T��喳��#��i�������r��*�7T�[U��yG�^����D��Μuvc�u9xi��|[��R��#�RPP3�g{8e��~c-͵����r�*R�.#�����Fa�g�m�>	���.6[N[PC��-�5��2e��e��>e|���_��𧻓�ox�����W�?\��ƣ���,�~      �     x�m�M�G�ׯN���$�W/��@ !!�lr�!^��c&x�q��B�F�TU=�n�,F�տ$���������.����}�^.i�^B|����C�&�����[(����P]�nGa��������B<�qJ ��=E���|}���}~��?,� �^p+�܋�
8��+��c�S?��'xhGj��=�� ��\l<)$^�aݐN
7�C���S���Ƴ�E4�v�����PW8�Jx�@t��%9���r�HI��/����hRCs�nY�$�����eg��%t�@���r{rv1�+G��FL{���0I�R����sH��g��#ȣ<~�\Wә�w��^P�G��X:�0߫�2,��9����̌��ç�ǯ�����^h����\~�^Cɾ��^�'������|I�VO��].n|��*Z)�Yi%��[�%q˞Ĺ��[�%q�&|x|���>P�cբ�s`��54�t�`�G���	)�}6��-�6.��u���EݛCu�z�a�՗;W����v[r+Πr@3�>5�r~��W��ªe��G�_�ZN��:!o��[���ͻ��O?��;���1Z�
C��%$�� D���/��?�F��D��e��e-�U�����M�ԏH��j�$ѐ,�X"�Z���%��uΆu�l�"5B�Q��ZM��Z"��\,�\-�\�,gL��s6Ds��	����V�۳�<��<y��|N�`��C�������{��RQl�KA��<8L�!r�۠�YR�%����)/$3y���K0�(�$h�FNDc�.\ֿ�Ђ��
�<
��-���-3g���h=���J�
<*����6tTv�Qs���Qf��/�e�}ts�1�x��h�_g�ח8㾾�����q�1͸�D��t�{e%;�,���(���ݯ9��7�2Gu�=�lV0a׊���U�P��&K�N����2�w5a��&��`��H��-�CN��J��p���rZ�!��l�}c9B�Xw�ec�C~S��6��?�{��      �   �  x���MN�@���]����)�E�ǉ�)����NBLb�����h8C�F4��F,�=ի�W_!�QF%TW͇J���zU])٪��=��S�����&ͮ�<�eԣ.�{��
��nf�!,���r���f��
y��y����� Tl;�3�]�������GI��,���-+
��Q���8 }��]�!>U����3��d:�6��-��L��.;���$�ˣҐ5)��t)i���S��	e�Կ�#�/����ko�C{�_�I���y�.�Ć���
J�O� F�gg��7��*.ճe����8E�uJ��� y�Xc���Ǥ��1��y
aW����;@�]������V#k|���:�7X>WdY~
�'     