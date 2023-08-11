PGDMP     ,    /                {            t-base    15.3    15.3 ]    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false    221    240    240    220    217    217    219    219    219    219    219    219    219    219    219    219    219    219    219    219    219    219    219    220    221            �            1255    16654    qqq()    FUNCTION     m   CREATE FUNCTION public.qqq() RETURNS public."cleanSns"
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
       public          postgres    false    231    233    233    231    231    231    231    231    215    215            �            1259    16514    orders    TABLE     �  CREATE TABLE public.orders (
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
       public          postgres    false    227    227    227    227    227    217    217    227    227            �            1259    16636    wearByTModel    VIEW     �   CREATE VIEW public."wearByTModel" AS
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
       public          postgres    false    238    238    238    238    217    221    221    217    238            �            1259    16567    deviceLog_logId_seq    SEQUENCE     ~   CREATE SEQUENCE public."deviceLog_logId_seq"
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
       public          postgres    false    219    219    219    225    225    219            �            1259    16509    wearByPlace    VIEW     �   CREATE VIEW public."wearByPlace" AS
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
       public          postgres    false    230    231    231            �           2604    16586    eventTypesNames NamesId    DEFAULT     �   ALTER TABLE ONLY public."eventTypesNames" ALTER COLUMN "NamesId" SET DEFAULT nextval('public."eventTypesNames_NamesId_seq"'::regclass);
 J   ALTER TABLE public."eventTypesNames" ALTER COLUMN "NamesId" DROP DEFAULT;
       public          postgres    false    232    233    233            �           2604    16538    orderList orderListId    DEFAULT     �   ALTER TABLE ONLY public."orderList" ALTER COLUMN "orderListId" SET DEFAULT nextval('public."orderList_orderListId_seq"'::regclass);
 H   ALTER TABLE public."orderList" ALTER COLUMN "orderListId" DROP DEFAULT;
       public          postgres    false    226    227    227            �           2604    16517    orders orderId    DEFAULT     t   ALTER TABLE ONLY public.orders ALTER COLUMN "orderId" SET DEFAULT nextval('public."orders_orderId_seq"'::regclass);
 ?   ALTER TABLE public.orders ALTER COLUMN "orderId" DROP DEFAULT;
       public          postgres    false    225    224    225            �           2604    16498 	   sns snsId    DEFAULT     j   ALTER TABLE ONLY public.sns ALTER COLUMN "snsId" SET DEFAULT nextval('public."sns_snsId_seq"'::regclass);
 :   ALTER TABLE public.sns ALTER COLUMN "snsId" DROP DEFAULT;
       public          postgres    false    219    218    219            �           2604    16499    tModels tModelsId    DEFAULT     |   ALTER TABLE ONLY public."tModels" ALTER COLUMN "tModelsId" SET DEFAULT nextval('public."tModels_tModelsId_seq"'::regclass);
 D   ALTER TABLE public."tModels" ALTER COLUMN "tModelsId" DROP DEFAULT;
       public          postgres    false    217    216    217            �           2604    16500    users userid    DEFAULT     l   ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);
 ;   ALTER TABLE public.users ALTER COLUMN userid DROP DEFAULT;
       public          postgres    false    214    215    215            �          0    16547 
   accesNames 
   TABLE DATA           ?   COPY public."accesNames" ("accessId", "accesName") FROM stdin;
    public          postgres    false    229   g|       �          0    16464 	   condNames 
   TABLE DATA           @   COPY public."condNames" ("condNamesId", "condName") FROM stdin;
    public          postgres    false    221   �|       �          0    16457    dModels 
   TABLE DATA           >   COPY public."dModels" ("dModelsId", "dModelName") FROM stdin;
    public          postgres    false    220   �|       �          0    16568 	   deviceLog 
   TABLE DATA           i   COPY public."deviceLog" ("logId", "deviceId", "eventType", "eventText", "eventTime", "user") FROM stdin;
    public          postgres    false    231   �       �          0    16583    eventTypesNames 
   TABLE DATA           C   COPY public."eventTypesNames" ("NamesId", "eventName") FROM stdin;
    public          postgres    false    233   �=      �          0    16535 	   orderList 
   TABLE DATA           s   COPY public."orderList" ("orderListId", "orderId", model, amout, "servType", "srevActDate", "lastRed") FROM stdin;
    public          postgres    false    227   >      �          0    16514    orders 
   TABLE DATA           �   COPY public.orders ("orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName") FROM stdin;
    public          postgres    false    225   �B      �          0    16419    sns 
   TABLE DATA           �   COPY public.sns ("snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder") FROM stdin;
    public          postgres    false    219   �G      �          0    16860 
   snscomment 
   TABLE DATA           6   COPY public.snscomment ("snsId", comment) FROM stdin;
    public          postgres    false    240         �          0    16410    tModels 
   TABLE DATA           ?   COPY public."tModels" ("tModelsId", "tModelsName") FROM stdin;
    public          postgres    false    217         �          0    16401    users 
   TABLE DATA           P   COPY public.users (userid, login, pass, email, name, access, token) FROM stdin;
    public          postgres    false    215   (!      �           0    0    accesNames_accessId_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."accesNames_accessId_seq"', 1, false);
          public          postgres    false    228            �           0    0    deviceLog_logId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."deviceLog_logId_seq"', 9, true);
          public          postgres    false    230            �           0    0    eventTypesNames_NamesId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."eventTypesNames_NamesId_seq"', 1, false);
          public          postgres    false    232            �           0    0    orderList_orderListId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."orderList_orderListId_seq"', 1, true);
          public          postgres    false    226            �           0    0    orders_orderId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."orders_orderId_seq"', 10, true);
          public          postgres    false    224            �           0    0    sns_snsId_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."sns_snsId_seq"', 6946, true);
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
       public            postgres    false    225            �           2606    16874    sns sn 
   CONSTRAINT     ?   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sn UNIQUE (sn);
 0   ALTER TABLE ONLY public.sns DROP CONSTRAINT sn;
       public            postgres    false    219            �           2606    16430    sns sns_pkey 
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
       public            postgres    false    215                       2606    16576 !   deviceLog deviceLog_deviceId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES public.sns("snsId");
 O   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_deviceId_fkey";
       public          postgres    false    231    219    3305                       2606    16589 "   deviceLog deviceLog_eventType_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_eventType_fkey" FOREIGN KEY ("eventType") REFERENCES public."eventTypesNames"("NamesId") NOT VALID;
 P   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_eventType_fkey";
       public          postgres    false    231    3321    233                       2606    16594    deviceLog deviceLog_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."deviceLog"
    ADD CONSTRAINT "deviceLog_user_fkey" FOREIGN KEY ("user") REFERENCES public.users(userid) NOT VALID;
 K   ALTER TABLE ONLY public."deviceLog" DROP CONSTRAINT "deviceLog_user_fkey";
       public          postgres    false    3297    215    231                       2606    16619    orderList orderList_model_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_model_fkey" FOREIGN KEY (model) REFERENCES public."tModels"("tModelsId") NOT VALID;
 L   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_model_fkey";
       public          postgres    false    217    227    3299                       2606    16541     orderList orderList_orderId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."orderList"
    ADD CONSTRAINT "orderList_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public.orders("orderId");
 N   ALTER TABLE ONLY public."orderList" DROP CONSTRAINT "orderList_orderId_fkey";
       public          postgres    false    225    3313    227                       2606    16524    orders orders_meneger_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_meneger_fkey FOREIGN KEY (meneger) REFERENCES public.users(userid) NOT VALID;
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_meneger_fkey;
       public          postgres    false    225    3297    215            �           2606    16474    sns sns_condition_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_condition_fkey FOREIGN KEY (condition) REFERENCES public."condNames"("condNamesId") NOT VALID;
 @   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_condition_fkey;
       public          postgres    false    221    219    3311            �           2606    16469    sns sns_dmodel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_dmodel_fkey FOREIGN KEY (dmodel) REFERENCES public."dModels"("dModelsId") NOT VALID;
 =   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_dmodel_fkey;
       public          postgres    false    220    219    3307            �           2606    16529    sns sns_order_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_order_fkey FOREIGN KEY ("order") REFERENCES public.orders("orderId") NOT VALID;
 <   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_order_fkey;
       public          postgres    false    225    3313    219                        2606    16431    sns sns_tmodel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_tmodel_fkey FOREIGN KEY (tmodel) REFERENCES public."tModels"("tModelsId") NOT VALID;
 =   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_tmodel_fkey;
       public          postgres    false    3299    217    219            �           2606    16553    users users_access_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_access_fkey FOREIGN KEY (access) REFERENCES public."accesNames"("accessId") NOT VALID;
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT users_access_fkey;
       public          postgres    false    229    3317    215            �      x�3�tL����2��/�N-����� E�      �   ;   x�3�0I�bÅ6^�w���V.C�/컰,���>.#�s/lU�؈"���� ��#}      �     x�e�]r�6��/��QM������f��8��T��⺤.� HY ���:�Dс/o�~���ꛋ|ܩ$���F\S&psՒ�W�fr�8���/;���^�o�t���pp�y �V�3���X(B5��������.�C�DM�b���a�]u�*�<�X&FͪE���1
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
%Z�J���c�۷@���r,��Pv (Ѳ?h�Dì���N� J��M (�Ol4'�  ������7�,Fo��X�!�c�`\@���q9oƅ��D�H����c�r@�E|�� %�K�& �hH\#.ŗ� P�!q�S_ �@���5RLQ|	� %\���7$(�b��kyw (��C�2zC0)���8�[�7�b���C�)zC0)���8���7��X��H@9C`)��Ѽ@9ic� ���5�@��A��c����;K4� ��H��� ��H�T� �DäJ9ym���cE�e�; )����4�cE�M�; �DC,�XQ|��@��a4"�"�Qv �"��v�9Ѡ�DJ4��D�� %�(Ǌ�Kqw (ѐ�FX=�o���DC����kd��7$��!�ސ���z;�]Kv�:������@F2���Y�0Vˀ2`C�'�%ٞh�հ ��u���E��E��+b�Zh������s/2�X��s؉Ex��(��%�n< AHx,���	@�����CTi�_x,���	� +K��v�JTN��'�B7%* �(�2�J��v�D������
�c	�L ����X����(�\�X�� %*�><���k���|��'P��@X�X��M �K�µ	���%pk��5Q�K��	��

�5Q��IǺq%��z�J$5�ĕX�X�)x,U�<�*�@�akb|I+���B*x,�; & J��尷��	�X�M �(X��%p;�@��u^�'p;�@��u^�X�M �(X�ܘ_� %
�9w���M] %
1��%Py?P������b�D!H�([� (Q�����' J"4�(�{�&�)Q�
�N,�W���	��"Lg<���6 %
�{��v�3K�Z�	`J�s�5Q�K���	`JT (Q�C)x,�k0' J�TK�*�	��<�R��^P"K�B֯�jJ^,x,�kq' J�DK�����X��+x,��B�(��+x,��J�(��+x,�S3 ����j�D!W�cQ6x,�Vc��� P��?�c)�� ��(�<w�����KQ�x,E�tS��*�e��R�����D��/�{ %*�8<����X���c)J0nX��0�X���c)J0nؚ(�`���h�W�)P)�q]�c��b�`\�X㺘�"��<��.��u1�E�ʰ�JQ�<�)Q��(<�@/�	��`S	�c� vb�Og,��4P���b*��H %
�8,�h�6P���b*��: %
y�XL%�Vg�D!7����7P���G:V	��� (Q��#���M �(�摎U�� �!H:V	�W� vb��i'a=�c)B,�t�R�X�X��4ұJbi�c�"�|��U��&�)Q�����
 %
�5�X��5����5a�R������!*�� %
�5Q	4�� (Q��p��|�b�J��XZ�:!��CTNe���҄�4ѽY&K8D7@�/ �3�c�B��R�ciB�#��	����@���( �(�'�Q�QP"K�<IǺ��	�)Qx�4S��^�c�UF:�������t� ����DaE�c�B0�$��<DS���4�Ԇ�Ҕ=R�5QP"KS�0x,M	�4%��Ҕ�*K�&�_A��@X��X�P~P�X�P AO���7Ӱ.2L�
 %*Q<����X�
�D`k���X�`�Ц�~3	B�c�UV/{;�eog��D���4�W@�����X�SK]��X��v�:!���X���7<�&��4<�&Xe��	����҄�A�ciB��4a���X�����o��D<�&��-�㳑�wA�ӄ#OK��Kr0Xo���(�XK
4T��/��o!	J�ciBh�_�
K�T|)�4�"!�y)�4�&��٭DAٔ� �� P�p���~%�4�g��~%ⱴ"(��	I���o���lJ�4�X��jV�"�����	����X�0(U��7�c�/hV�"D0�ձ�fu,B	F�:���Y�P��z\O �X��'/��q=P���Ë��dO �(a؜�@��	��(�}���Yx���D�!6�'* �D!�Ӛ��Ʉ�����]a����X�`�fQ`J^mx,M���y,�m��cܾf�`7�Xò��"���<!8��0���)]9|?��Q��V��c�y�y,J@��)/�an��<���c~��cލ�Ǣ<ˀP~FS��.�5񲳳0�X��Z�WY���֬���c9���}�ʗ2���+ҽQ���. �g@*R���d��L$�K8��v��\ ��~�q%�w��C��7 �DRo@\�$G� A�	%
�o���%����_IE�?�0%* �(lq0��%8H�?� $<�C�XHM���r[]Rn��3����F�:�c9��B�#�!��Hϼ�z��ra�~�&
1�~�&
QݞmM~�̚(�{�����BH�c9��sϬ�B`�gS�@�B��B��B��B��BH��B,�S��"��BG/(Q��ꅷ��n,��%�&J:`MTtPYT�DeE���B\�W�����D!#�W��,(���
�V�Pލu P>J,��P���4���XJT�H-���|�vn�0�[ L����!}���C����<�C�x,���u<�C�d�J�������q��PB x,I�2ˡ���X%��r(�0<�C	��J8�����r(!Q<�C	��JX�%)<�������3�cIJ�%)a <��l��X����cIʉ�%)�@�X���L�v��%�:�$D�u,I�h�Ô�
�:�$�Tu,I8��X�p�Ա$��7�cI��s�v�+qPǒ���8L��EuPǒ�@Ԡ�%	'�A�!x��:�C(���΂�c9���A�!��X!�}��"$��X���a���>�c)���c߇y,B��x<A�5�<��d��"���X��pP�r���:�C�CԱB�砎��L�y,B}�0�E�oԱBU�0�E�·y,��=�c�P�y,B�0�Ep��y,���<!Gs��"�2
J.�Ա�] ���%���%�:�C(ԱBnި�D�+P�r���:�C�XgP�r���X�<qT�'
J��v�H�!TڎjJU�X��vPǒ��2u,�P0=�Eq����Y�u,I�u,I�u,I�K���ǒa�$�_x,I�K"��%	���cI���%	���D�+�D�_����cI��0�X��/<�$��%	�°��aS��&�$e���r*M<�S�H�y,J 
������r
���c9a౜��0�XN�_x,��/<�S��aɗ�ͻL�x�>QX�XN���c9�D�`�O�d��R���0%*_%
ǅ�r
	a7 >�,��@f��K����������Nf����r
Y ����F��$!(KV��jt�ǒ���cI��q=u,�Ȕ"T�� A��V���D!�A�k����ew�	g��^ѳr�u��s���� K��(_a �LK��u,]8�\ԱtEԱt��y��WV�\ +u,]YT3J��WF�����(Q8;_�V�P�8Ŕ(蠘)�[�C8p\��m��qr����E�PU�X�pv��c�v�:�!��bJV$�X��ݧ�eGߋ:��l��c�v�:��l��c�i{Q�2��ձ(�>�cQՔ(̅fJ"u,]���&�^�_���Y�����.u,]��P���`�q�A�YG�~�Yw5��B�꼝�����D!���(Q9tu�(dr�C���M&�+g���sG�Bv W��.dr%N�B	W��.��\�������9w�c�J�����Pr<���]��'w!��+qrWBa%
)U\����P��Ru](Qp���)w!���rR    ���6 A�x,]���܅�*n��]Hp��ܕ��eJ� �ƒG<�g��|���%>!!pj��V!pl�OI�[�3��v'������%�<C���7�k�F�-M�'4_� ���[��o\!�&��!�&�/
h2~���&�54_����B@��=4�C��!��&��Vh2u��&��Zh2����&�qsh2��܄l��h2n@�w�2/paF�@�`�nE��4�(
#f�7��d<�
���MA@��©��3�S�d�t
���NA@���)h2^=�EQf��[�@@��h2^�MƓ�o��2�<0h2~o4O섀&㙝�d<���EQf��/!�`�nef�=/҅�&�a��`M<�Mƣ��d<�M�C��d<��4����4#^�M����d�遀&����-�h�f��h2^���݊̮�gA 6O�pkR���C��0 Hz� (z����BH�5
�F�
��d��87B;B��IEQX7B�a�Iefa��!�Ii/�}#���&����}����%�*��L��0q���Ф��L�ҷ@�J�4���!�IejY��M*�bn��BfhR�sXzC�uR��Tv�\̖�^�7G��M*'Vn��B7fhR�sO`�1C@��K�m�Y��M*;s��Mٙsme��|�}'{w+���:?B�5)t1��&��*�A���8B�l�27�q��.ʓ��}CH��E6M*�G��
�4)=��x�:��x=��x)��xE��`E5�oaU5��q��I|�.���8]��bՆʯ��ӕ(
U���kk X����������K�b|���>NW�r	�+q�TM������J#UӤD��r��&��\���J\.��t%.���F�$+�Q�r�jm�=��(q�d�6J\.Y������iJG���x��8J�c��iJNN��Z�C`?��&|���s_�MP��#4���~R��L��(~w2G�~L��(���|%�6����6'�q�<�d>��ۜ��Q2���8J^q2G�M��Hg^�q�|�d>�1Gڙ��#�@�Ǒb ��H��q�(��8R�|%3���d'+ǉMC@�Jv�i>��}���d����(y��8J^�i>��_}�������(��\����or�ۭIIv�T�x���R�$>N�_/�3NR��ӕ�7:�ef�����p1��E�����s=���i�na�%��+����8�r0�oa9��:-C�Y���������#��!8��J�Or%\7�{�_�������� 8�+��\aVB��\�VB��\iWB�	����&����`�t΋��&�+MzW��@�M�+Mz3�V��f�4��,Z	�U��b%�&=['�o�&�;�`�������h.�iq%�Io�a%�I�iq%�Ioe%�NzO�+MzO�+MzO�+��IIh�{Z\	�Ie^Д��W���W���@V��FzW����W���+��IE��4)�MzO+�4����~R�������J@�^wr%�I�;�Фם\	h��N�4�u'W��z�+Mz#9+MJ� �\�x�J@����J0M*k�j.of%�Io,h%�Io<j%�I��}%�Io�`%�Iolp%�Iod!в��f�Ӥ��Ѵ��F�V��q��&�9�+Mz�iV�����4���_	��V�&�k�S;L�4���9�+Mz�V���G�4���[	�&ݷ9�;wK4�*Z	hқy�Ф7�p%�Io��BH�N
�"����f�Ӥ2/�dsy3W�7�w%�Io�Jh�zx3�WB�	J$'ߛ��nȻ.ʓ�7��ݒw%����H�)�+!CP~͓��#������4����&���D��.(�hR��&�]P�hR��&�]P�hR��&�]PF��.(�I�	�M*Q��Ѥ��Mz�YBA�J|24��'sA�J|24��'��8J|24��'sA�J|2{w+�*hR�p�&��}�hRqHsE�J�@�hR��M*���I%s W4�d�j�nE��4�(��:)Фt�kh�[��Ф�M*���Ф]�M*���Ф]�M*���Ф]�M*���Фt�붟T>��8�<�`g���Ie��h�[S�Ф��x%ع[zhқ˺Ф7op%�&E��㭞��}��dӤ[3M�}���&����`������3M���3M���3M���3M����b��Gg�ntq&�Itq&�:���B����L�s�2/.4���	hҟ90Ф?s`&�I��WB9Ф?s`&�I��L�uR�d9Ф?s`&X,H���&=Ɇ�$}��*��+a@�~��_w�⅀���[�an|w�ꕐ!(s�ݏo%ܚt��[	�o�(*�Ido&�&���L���p�&�wV9Ѥ?�7Ф?�7Ф?�7Ф?.7L�ʼ`��nM��8��Az��I�[P��n���3���M=��/�J �E�	�2���q�F_	�Ievg['%=\|evӤ2/��q�7_	h��	h��	h��	h��	��J��O*�,�II���ڇ�PM��w����	���(J��}��J�����g�n��?Ф�s�	h���4�D
�8���z�}�+M*Q��L�ʯI=��v���&�i��}K�J@�JL�P���r%�I%�X��qߚ���q���L��̢���zf��g��;�H���8�&��q70_	h���4���g��{����|%�I��L@��Lԙ�&�Y3M�3Qg�iR��4)}4��e�	���&�ٰ�z��φ�	��T~�q�?�d&�&��uY|R�-�����@�tb��ݟw%�b�����΄J=���J�ܭ�'+�8��+�s���V���'+>�P��|�}Q�q����iRx�U|���*>����J@��.���eT�q����8C�U|���j2M*z��Jt���%T�iR���w+��R��R��R��R���1ev��%>Y��Q��|ť��8C�OV�WM��8�CZ��Q|�j>��{P����YT��o�����M�&��'����I�&��'���J0'pޜh2�5l?�W�D@���D@����D@����D@����D@����D@���D@����W��8�H�D0�[���8#��Ie��������&y�M�'��N4��h2�7����3�7�Ӥ�|��.N4�GMӤ�-�#}4�.N4�N4�N4��}%t['�o��3���@|R��uӤ����@��D@��v"�&��&~�D@��z"��@��W>�dL4��O�ɀ�8�dQ49� E����hR=>R�$4��b&�W�����w�W�qN�ys&\�ss"P�s�O�3!Ap+j&����D����D(ܳ{&�I$g&ܚ��h�L@����L�Z�$�8���J�mv����LHM�6�f��62A�4Z�ٟ;*A�4Z��e�	�NJӤ0/h_O�Nl"$�I��3X'�>�L�uRy��u��g��I<j&�N�}������̄AY�W��{�3M�}މ��j�?N;Ф��	h��-�4�w�g��g�4��^�	hҟA1Ф߭�	h����4鏙O�l�TT�M����W���3�w���R��xw��(3�w���5xw�O�3�w���8xw�O�3�����<�W-�O�3���?z0�O�#Z3M�#�3�4�_''���Hg��ǣf����f��G�f��GY'��e�t&�&�_�{ղ��	h���4�wHg��G�g��;A3M�����&�N�L@�~'h"p�Z�{j3M��ə`�TTͽj����4�w�g����3M��&��L@�~�~&ػ[�-�W-�sf��F���q~��� ��eodo%ܚ,���J(��b%T��b%4�y�:��W���J� 8���j-���J�5Y���J8��&�W-{��+Mz���&�����&��ꕀ&��?��I��Ф���p�&�U�x+�W���{�X'��I+�4��|    ���fY	hқQ�Фw/�X'�1����E�	�|o�s%���FW�no�v%�Nz�+���7ڼ�Oz#�+���7��Oz����:��PV��z(!�&E��do�y%�Io�y%�&�_'{��+Mz��+Mz��+Mz��+���ҷ�uR��i��v�Q4y�G��i�IE��8ٛ��l���ŭɪ��:>N��|�*�q�q�4��q�4��q�4��q�4��q����ǩ���ǩ���Hj�f7>N�f7>NS"\�T�4��q��N��4����S�)��m�M�`t|��DQ�\�V%����i��ޜ���:)�/�iR�Y�8M��p�E�Jt�K4jU"�\�[��[��T%��5�J;1|�*�7�q��}X	hқ��L�ʯ��S��>N�z�+Mz�敀&�^�J@�^�y%�I�׼Ф�k^	����+Mz���~қͲ�q��1_	h�[�Ф��w%�I)���S�(
>N�f��['E��T)���S��>N�"Z����
3L��g@�RL�J-|�*EY�q���f%�IoE�J@���aV���M��To��B��iެ���GZ��q�����i�;�I�M|���\	�q��>N��0�8͛A��O*{9.�Myor	xm�;���kS��\�^�7u%�Io6�J0M
+����L^	hRY����6�E��ڔ}�
jS�84K�My�а�6�Cӈڔ7�+jS��4ϨM9�r�|mʞ�f	�)�(.4�M9p�Dm�.�+0jS�a���6o�J@�JfבԦ�p%JmJ�ײԦ�`p5LmJ�6զdPpENmJ>�����L^�4)Ф7u%�I%Êk�jS�0\U��'��U�)�j\�U�73y%�&�w��8J��0�[U��q�7;z%�&�oa>���a%�Iof�J@����`��L�ʼ(3��&�+��IE��x�PV���ʓ��)����)ʹ�ˆjQ��\�T���Z�=->N�v��8E:���i_��S�]1>N���8E:���霅�S��>N����8E��s}v-J��+�kQbb\#^��F��%w���kQ��%?jX=��I2�G��X=��V��Qr����(>ΰz��V���8��qgX=���z%VL��Z�=���HQ5�Ǒ��V�#���G����i?i�8Ҟ��q�L�a�8�i��q�����Hg�Ǒ�8V�#���G:�Y=���zō�I@-��`�HO%,�
j	�QM\��`�fM4�/&��Q�4)}4p�&���&�iR"�ɀ����S��D@��|"�~�?7'��i'�d�Or0���@F f>����'9Ҽ�ǩ��+��E��85�L�>�D /Hz_��TI��85���h2����Ie^X=N`?9�d`?��`�8���D@����D@�?k"���>j"�I�e�8�;��q�w����Y��]F@����D0M�U��`�8�=�D@����D@����D@���D@��S�D@����D�w��-�d��k"�&U�O�W���j�IE��8%P�7�O��&��@��D`?���q�U�3N��g"p�	TM�8�ʦ��&�U_	��*�&�d�nq"�N��&���N��@�D�3��j��	dqL��@��D`�dM�݁�ů��	T�M4�E��I���;PK;�d��v"ܚtw�-g�������	�&��W��3�W��pk��yj!��;���spϬ�pBpϬ��!�W��P �W���&���L@��H�L@�~�}&�&U��;-|w����&�gޙ�&�1���&�'���&�1�&�yA3�4��n|��?��4��Pf���qM���n%�I&�L@��L���&��f3M�s�f����g��gP��d��wФ?V<Ф?^=�q�]DW��{3M����pk���~%�I�3l?)=4����4����Ӥ�$Ѥ��8�q���8Ф��8L�ʼ�����L@��X�L@����L@�~�`&�:)=4�x�4�wa&>���J@����L@����L@�~gp&�&����3��L@��x�L@�~_o&�:�h2ۻ[�d�w���b�nE��8���	��>í�K�-�q.i?��sIs�N�7a���p�����sI��ǹ�=>�%�a�q.ig^M�ʻ��0�8��3�ǹ�5
����8�����\��NI�8���ǹ�}5>�%���iRYa����g�uR"�I!��%�����sI;R|�Kڑ��\Ҏ�N(�8�e��E>��[�:)}���,Й�~ҟ90�O��&��8~�x&�I)�1l�����'=�����gg��L�����	hҟ�1L�ʼ0�_�8�q.���3�3�?f&�I�[=L�ʯ��sI�,|����L`��g/��ya>��t&�&��!��㯄�	hҟ�>�#(*����4�	����$뤿v&��#={wK4��~�	�IA��|��L@��[f­�.8���ܚ�ʉ5��t儒�q�H�8]9�%�WM��%|����>NW�r	�+�̈́�ӕsw����~2��ti����ʻ;��te_��q��I�8]��>NW��|��,!�&%�T�0	�+'���ӕ�{���J�:��t%f��q�J�8]�?�l����J�!��t%����MJ��b�nE��8]��$|��D�>NW"���&�7�ݫ�Ă�ݫ&�ޛ �U�v��8M�&%|��D>NS�r	�I'5|�&�/�q�t޴�8ҙ����ʻ���(g���Ӥ�>NS��>N2�o���o��n�T����~R���Jd/5;�(��G��8M�'|��ĊS�uR"�I%қ��q�y�M��oa��[ع[���V�>NS��i�G���8]�?��tI��8]zo��ti��ӥ]>N�v �8]���t鍃�ӥ>N��&>N�v �8]ځ��ti��ӥw7>N��0�8]����ti���ӥ��e����8J��4Gy�V���N�q�}�i�8�>�4G�G��8]y���iR�ݧ�8J�����ʻ�����N�L��V4i>���9��Q"��8Bm�M0MJ����M&��K��Ru��%�e��!g�$d�_s&�&��r}*�o1�M��fB��^af�^af����p/�7�=�fB��V�L@���L@���L@��Jؙ�&���4�?�4�֟	h���L@��z���r�I�j?Ф�6���&��3M��ə�&���3M��Pg���2Ф?d&�I��<Ф78�X+�=�L�uR�5�X+~�z&d�g(��Py����X+�����!(��wb����3Ⴀ�r�iRY��Y+���L@����L@����L����$Y'�񇙀&�y 3�u�E�	�����L�uRy��w���9X'��͙���ޜ	����`�I�I�&��6�����5Ф?N;Ф?�?Ф?�?
��G�K���'�uҟ�8��Y�o�2>r�$dnUτ����P!�g�Lh��b&t�_s"nË́�[����MpϬ��n�v�4�?-�Ӥ^L4���?�ܘh�v��	h�_C:Ф��t&�I��L@��*ԉ�Ф�ƀ��&���3M�3g��g��ӤD@��lؙ�&�ٰ3M��ag���.�4�φ�M���g��g��4�ώ�	�IE����'�G:>n!?4�uV���+Mz�]\	h�{��J@���'g����S�+Mzo�\	h�{��JȯJ�����?�ŗ��������������~��~�ӟ/��G��|�/�x�����o���%>�3>��Ɵ���Sx<�0G��'~�+>�d���G-��d���G����x�W�����GW\T�QO=����o��G-�t�����O�����(z
�o����T�Q�?_?�ޣ�-:��=��������n������v <����/N�	���\(�/���xA?�������ֿ��_.a�+'���߂�F��[П��*�o��_Lq��7��+�o��Gt�V��D�i���z\��������WM��C����?a�\џ���O�?W�'���������_�맡�&�7��׏f�߸���q�5�W��k�����_�믣���v\.    o����T���"<��o��
;ZF��s�M����[�����ʺC�����ABx<�;�����v��?����#��a�>?�;�����G�����X���}
]������?�G�(����x��_�ƻ�����{��o����{�����[�o�����w������.����=���.������i���/�����]ǣ?��w_�o;�]�u|g��������[��|�e���(�w�[�'����Пo�����/����/>��O�����'��S�����]ǣ?_�x�3�_��џ/~��?_�y�Z�g��ן���}��u|}�������}��u|�����[��y�[�_�xa�̼������?Yǳ�	�?��7���M������$a��$_�e������Y�|�e<�r�Vx���_a�����'̟��'�?Je|��+������	����w��_X�|��2��������˗?��G%��+�+�߯����wE��[џ������ϟj����Uџ/���o���OC)��f�_��k�/i��'|~[��󧡿,<�'��+��7�ş7�����|�u�����m������|��u���;������	矎���CGB�c�?!�2П�'�[����싿����ߨ���g4������������������}��2�#���u|b|\?��/�f�����2�	�C����_?���/�?|�g�x��������_X����/���/����{|x�q�o9��g��������=>�?ڟ������=>�?Z�ܿ��%������q��O�M�߿���q�����/��%�=>>��?N_��:���W����~?�w���i������}��x���h�q����Dq���&����N���i�r����D��?������g�G<~OS�{����3?���=>>��?�x��vO������8��GZ^����/��W��M��W��+�G��W��#�7�?����#�7�?����#�7�?��~P����N�G���;�9�?t�?���P�������?�?�?r�?���ѩ��q����x��Gq��S����W��#���G�G�O��x��S�����N�GN��G�G���t�?r��?�?���a�������#��n��Ͽn�?a<����	������+�G���Yxt�'�_�����������@��u�?����Q���n���6�#������w�?������x�y7��W���G���e�����u<��Տ��M���#��/����ڪ�,�/�?�����B��#�K���_���x��C%��49*9���R���=���i5U����u��?��o��x�������с����ߑ�����#��#����w$[��?�G��G2�	��_<�}��6�?r������a�G���9������i���?N������?�GN���s|����������?��a�G<~6����φ����0�#?���?����?���Ox���!�������|�8������_��������>q_��~����O_Y�W������������*/�j��잲-���;˶������¢Gv�Ģ[���U��6������¢��.֭���u�Oc��}ݤ���7͡��qo�֭��K����9tk���ºu�7i��v�����gߊ�J���>��U�;����sA�Xn[���k{`�s��]*_]���熶=��m,?w�큕�"�=����֞+���s���x.����������\���;�������=����V������s��X{.Y��ύ�`'�Kv}w}}��~�����~���_~c����w7����M��WJ���q��>j��\b���]ύ�[`��\o�����������=��܂�V�+����s?�X{.������{`��{�z&��u��{`�m�|�����=�{`幔z�>7T��=���]�6�F{`�s+���詛�a�z�=��e�{Ҧ`�|Ү�Y�k���>�8�kυ�{`���xl<�$����^�-0k�k�[Ǡc�D�}����.�=��\��V�[����se�X�O��e�{`�s��X>�k�����so�|.���O7�=����O��=��4���O�=������2[`�2i4����}{`��s,?�����s�>�2����6s�?=4����Ps�z�kn���i������{`��Dl,?��������*)߰�����+)߰�����RR2Vv�&���N��d|�:���oXYI���U���oXUI���Ք��oX]I���5���oX��������d|�JJJ�7�SI�������oXEI���U_�QYr���O��^�Q��6���p-������Ite]�,Dy�B4~e��)x�+�|q��V~�¹qe��)D�VV}q��V{q�����+랽��{e]6�����V�=��j4PH�������ӯ��/���O���������~R���I��r�PNB�˟?C~?��=��b�6�<�!<�$|G��x��E�o�I�wᾍ��	��ڪ7,}®��l���Ӟ+(�7اT��>U�vϟ��>��q����eW��ח]��^v�Nx|�U:���eWф�_/�J':>/��)<>��*����eW��ǣ?�-bo�џ������q���x��B{������G�*�����qڷ�O�_|����q��x���m<�s܂�6����N���m<�s��6��'|���m��/��g��b|���p����/��Z�h�冑��Q�'�<W����~�=��\ַ֟����s����ܩ�V���=���6�v>W_����=�Ϧ�{`�鰼֞v�{`��;rl<�T�������B�Zuo�����;��{`��ĻV���{`��ѻ֞��{`��޻6�V�{`���wW�&�{`����v>���姗�Xy.���O��=��\Y�֟����s�����,�fה���Y�k:=�n���m��ޛ�զ�t��s�id���M��P�]��\�v=w3o��E��*�7Xzn��;�+����s��Xy.����M�{`���{�?wH�B�=��|�iU�iq|��mZ�����=0���״�]�%�o�����kO��=��t��OK�=�������i6�����{`�ӆ},?=����Ӡ~���`�iݺ֟>�{`�ij�f��=�)��v�{`��ݽv>�������{�<-������{�=͗����	|l<m�����G��y<�����=|�|Z��姯��̀]��>�����F�z��شj��H����T2��O�tD4�5m:"���"�`v��kff�� ? ZU�cD�>�`�lZ�xe���bo0�m���V���llZ�
3`ײ�+3E��`66��w��ű��t�O�w�&C&�	���N�vA�^u�vA����.h�J[���S��)J�+3�]{����;���i�W�m�u<�e��������p��,=]���Χ%����ߴ�6kv�i:�b:7�	->.�y�Q��+HҬA®_Ӻul�5y\��+��sת�mlZ5�������<������{~�=�����ӕ~l<-����_�����+7������'|�����+O��=0��^�x��&+�	��[�`6v����6�����M��>�7I��������]�%�yg�&�73 z���vA��m+J�^��c�Y�j�&�o`�U�n�PN�A�M�߉pn�$���{~�Ӛ�F/�}���3�NkG�Q�F^P�.�73 zG�������¬��c�i�L��s��l�y	����س8�������*�M3��Fo.~�Yw�M�%wn
G��7uS��&��bA�uT��5����D�M�i�W7U{خ=o�,��79bvΛ�:;�M�3;O��u������KOO�=��i����n�{`�6��!���kdkJ�inZ��#��G�ش�Y��p��{<�M{ ;  Z����xo�ގ����k��tx=�7o:V[�*o�=N��d�Ы��m�8�y��J�[g�`�����u�����>��է��gc�=��ti��l�v=����g3�=����{`��w����u0Ox�	�<�]��w-�V'�)�i��ܔ�oa��)�mz��[�2�
`Z��Ъy��,�w���Nxס��7���W���s�.�Y���<�Miv�_�����Y˻�
�<K+U����Rm�.DJ}�y����)�iy"R�ӷC�\�F��F��g'��"%���i������I!�H)<��Rꫧ�Bګ�	N��W����b;�3ϮD�(o-���}�ԇ�������eQmk-˟��q&3�[��θ!�O|��E}&�bqE�(kY|��yM?<���^�"�<��EJ���:	�u��)4�S�v�(����o�wim�4J��S���\i���e)h���4�$�\D��k�������ڽ�9m�I/���:Z���v/u���Hc��v���\�%.?]�U���X�?]�U���X%����PҮQ�E��4�&�r���غ��uŴ+?]�{�zao���?�K��E
�<��Z[���\j��� �]|g-�4��T�][�$���IG�ҟ�"��ʿ4�=���N'"�Ƴrp��]_D
͖U��<�oE
;�K�yp8�s ��C��0���_��v���]�D
�=����{�n�U�.��%�u�^��q��#NY�o�)���c�F�e�]�$<lϠ�F��g{3�.��[w��v���auN��EST��v��V#3�Ʊ�##7T��]y�|�v�����w�py�|U�I�\T�Y3R�_�� �}�6M�c���~�$���I�~���<�����������죵?_�6Z���rv!\����	�:���=�����l���/g�u�x9��/�4���>��`b����>��6j��$���ȉ�i|��9������񧇱��Q�OV~5���27!�#=?���P�ֳ�g�����I�O7\��� X��癈��t�)���� n�:���+�X�B�v���Q���1
}�}{�?F�C�o���(�f�}��t(�	0Q��d�J�_Q�p�kii,N�Sq��ݰ��t�,�����1½Ē�!�i��@ �吞�,��̜S!�g@����^Mf�o1,}%)4��Or"���W�D@���[L4Y��`�tn^V�,�s@���-�dU�l��
��I��l�N*�lh��L�7�D@�IQTC���[���_LӤ�-�p:�{���S�O�����8��Ǭσ^�~>j��χ�8"�|܎#���8��r�#��A�8��v�#�p��#h�^��1���U�ث�9h�^��12m��G���M����T��ǎ��զ��|�<m��S�w�Щ8k/�i��4k���i�:��|�L��o{�N5���U�mѩ��^�Si���j/�z�S�m]ө�~���"�t*͹z�N��K���O�E�E�i=L���ӻ{o����c�����)������88)%�Ii&pRJ�3�L�����5,��>k�;)�O)3�N���L�T��`QN�&��N4Y�z�vz��M��&���y1,�$}4����h2�5�d�+j"��,)��fd�4�y#ܛ�v�59nM~M΄�U/�x&d>��ל	���V�L�|�� ��Y3�Cp+j&nU�4�7��G�f�iR��A�?�?Ф?�?Ф?�?Ф?�?Ф?�?Ф��	h򐞃��ʯI�!AP�(J~/o
�J���7�,g��&e^�UQn��M�w 3M���7��{3�u�����I�37X'�{��`�nen6['�π&���L@��.7����g������?	M���3M����`��������b"VZ�o1*�34�Un"t~UO�A�-��w̋���z��4e^�|�+�D���]�Y$���J;*�A�5I6���$�Vډ0 (��85%P��k�D@�M��i��ޜh2���h�K�MvenR�ԛ2����Mzh�)s���ބ_��I�I���I�3����v"��&��0M
��Q�ٛD0M
��I��D�U���s�[�|Og��9���L`?�3�����	�'�z�	�q�z�	�q�z�	v�v�a&��=�k�$�!pƩ�ur&���ށL|���Κ	h����}R;?	h����D@��?/&���'9�dw���q���?	h�;��J@���~%�I�{%�I���{�|�+��I�`�S�+!�J*߭���_�ח���_���WF�h�f��QnF�n�я1������?�h7��n-֏1:��U�?�0�[��c��wk�~�Aef���?�H0�[��c���g���?��^����c��N|�v����mt�ֹ��~1�1����7"���#}���c�-t�3��9��я1n�~�*�C��B\M���ײ��~����Cp���)H��T��#
���7���~׋�Y+�~���:�+j?��j8?��|#�;�䊉��A"t�}��J�={�7�t��%��$�	��� xv�o���4�F@�._���&]�/o4�~}#�IW��M�rO�hҕ{�F@��ܓo	M�rO�h�##�IW&�M�2��hҕ��F�uR�h��x�Ф�uy#�I���F@�.��[&]��,`W>���AG#����[�����fY�~M΄������A��?����|�������Oa��?pQΗ�������q����_�l%[-B��ˊ���_V�������_��\/+��E�J���Vo�������_���/+����J~a���mT���T>������{(����{��^���Ʒ�?��n�)��ņ��q���c�3��W��R�����|}"R�ǐ3�4fE�ߝ�c��헿��o���?�G��E9��|��uO�隢���\���F��Z��j���;�g��7��?ԟ����!���Y��Y���:��!���w#����}���F���_����?ܳ���?���A���y|R�Fl����'�'�m���      �   |   x�5��	�@�����hbA�x���<
�-l�!٭�{��a���f���6��zՎ��-/�9n��r��v�K����,�~W��K͖F�h�Sޞ6�� {��Om�7f!ȹ��R�      �   �  x���]��*F�a�@O!	������JX���������:�GH�����D5�ĥ��B��G�����A�:T2'�3�D�����Az(4�8�8�q��\�� �%����[�r�9���~b=QOUߣ��GjA�B�Q��l�ko|b���l��@恴|^)����𥂪�{ۚ�rA��zM��h&=��'��"UV�-�$�)���ƶC��5�c-}�3���յtc�����t�P*�S݈$#I{=^q�b��A�M��[y	�m��i������~y�@���F���?��О�_��d���,�/X*���JO`G���T.a^��[�]�X�:}C_.�'�f!g������a���l�j�t��kY�k$�5���r�.��,u��`+c�XaX:�U̺��x��4�>F��]�E;�-��~h˶�f������	���H�{2�Ь^�ؚ�'=1�9�K��Y[������{m��9
�:]��oi�Z]��@d�z�2n�j��Z/y���]��jYyU[d���[-�FVYp/_��
�n_c~������V��K�G��~�u��M���:���;���v���2�t�F�����%M'm٬ �AӮ㗴]�Hj�����ޡ�[�
�=��q�^x� |�Ϣ~E��9�x�x��m��n�:;K��ǥ{<��Ux��0:�C)�����!��x#я�[�* ?7���-?�����6>W��!�zs%B^��AՍ3��n�B�<�^�r��zGt��W1�c뵖Ѐx��k�~
���>�-��/̭�Augn�^h~�mP)�[�WO��z�6܁>�_+��@��-�J(���6��T�QPي�������؊Q�^ؒ�Me[����2�q^���0*�X������W�sQ�m�<)�v���>EaI@۩�q$�hKl��Y��C�ｫ~���w�x��,0�P�XVr�e�o������}-��C��A�î�d�]��wo�mC���cB�v��*q��c��%�
���4x�
%��]iP�H���,|ȭPK'	���3�5O���	�vd��$+V�%�֎ܳ� {��K���P�ì�e��Z,�Pk�(�k�U��+TíZ�!u��[�P�vܜP<!��!i�5��Mj+�{�@����� �<��ކ4����k���"WC��W�k<�v�#j������=������/R
�?I����O��K�C      �   �  x��W�n�F}�~���tɥ$JE�_��E[ (�E�g+�p�ȑ������#JT��)���s��D[W�%��K���33g���.��0*�qqԌ���>п���mb��Ng�䖙|�&gJMZ?�Ғ]��V-����Ӓ6�7�uiJ���gM4;��#��;&m���� ����Mqi4-~�
:C9�������:9�Ora��۹�Ϳ�����iNL�.C�+�F�r"p�c��������c��Hj��[�߁�P��+�cOC�����G��|~��e�����x��<k����R�i[ 8��rdC+��R�}9d��қM\[�v��]oձ����%}���j�ظd��tGy܌��q}�����J��r����7�����?>�����X���bA����\��G���_�!v����:�p��nb�$�S�9j�g�2]�d�!��,��a9������G��|����*��xV�r�+W��@�f�(��NDT��2#`�R{�9{eٵ���k�b`Ó�yB":�����݆���53y��1��h\i���ϡ=��� �g��%�L@`'ʺry�O�"��K&�9� '���;�d\:bTX@�yCֽT.����bت��U�Ui���6��U=P���NCK�+���� j8�d&�����J��o�g*� wH!���r��&�jA���!Z���_�F���B��Ag�C�j��U�κYtVux �Ԝ���}5n��zb''a�f�V�c��9J�xA�R �;�]$/����7��*_@8�)%�`mm���f.��Oo_\�)�L��ĕI�O�b`"�m���� �M���0��9/�:H.�_*M3�$�9�*�f y��9Ʃ�g�ky@��� ���vf&�g�O��z1L[,��4����R琈��}��M�%���¥�W�GR���JX����� ���N\@96�1��0!�̴7m�*�oEu�i�0
ESĔ�y�*�*TD�L����֍��.7g9{\�t��&��M�԰�D"t���E�{6�5�j�58� ��Ψ��<���Q��ѪJ;6�.�Rw��P�L<����`z���6��d)q�!;X�-7�M��]@�W�d���7�7��L�*���F:�rj*�/����2U��:�-�ty3��g-�Ws�>�#�������C��A����!�����I��B��pۿ�#"2��/���ƘbqF�      �      x�Ľݮl�q�w]z�]I��;�?���$iScj�#Kz �]�Ȗ�0`��a����ly̫@i�A�d�^��9sUՊ���{��}bUA���ݬ_Ff�?#3#s���� $k�1��1{s�)����X�����n��p��?y��>Y�{:������sO�>���`���/�/�dl�����8N*�H[�L�WRi���8��ʤ ��HGeRR!R�N]R�$�z�eR�|?���Mڤ�WI��j#��s���R�fܶF���7�o�4`�G���w��?�mgX���T���� I��q �R� �l[P��/nc�n{H~��6K\�l2��� ���y�'�������6����1��I��?�ӂ�N䜘ɞ7BN�%N�l���*'�Μ�?�r
p���ʩ�I�1G1���Ɔ� 1GH� �B�}�9 U�W��^�&�H ���4�XfP�s�� �@ '�9��8��8u��Q(�努(8��<��?�����@*�R59�k�5<���HB�sM��t8��X��  �	G� b�Q�"P� �r��P�3���Y�$?�d4s9�`�r9�r@Z�:۳՝��
�u�N�KF(@�������*���
���Q�
E�*8���t�}�
�����`��)86@y�#p� ���G.>HBdj��ɩ��@\a����	&���Ѹ�� 	��wF�q����9�Q�)H8 �9��k�D�"(B`Ӫ�T��E����`���4!��1��5.�&D�'����r�F��3:լ>�&D����[
�PI����j:�@\f�*	�n>���΄iJ͛�م�s�N~P���.������8�=��������� Vg�ևXzj��2�sXKPgXt���%;��"�"��V�`�
��чMj�����6�/���O���m�BwS�#�逽�T?xQgS��m�\��ֶ�~���~ܖ6=r���6�yp�~*q����7ox���_���b���3q{Z$��sO��`�[/���0�vQ�b9%$��"Ł-��XU�x�%3[4)�QR�m�~�_��rbd��1z1�xy6^I�'3D.��tx�]�k����_����7�_��>��"��))3�mS����]�-"o��R�ͪ��+c��5�E�+0�0i�ۧ�j��1וS�k���������_���?�i]�������e��/Ͽn���ߟ����) "��%��^�K)�Q�����7��YEJ ����G��@)d�Q��s����������,��'yJ%�{��Ź��9����7��q���_Ͽjn��&����RZ�d��}{۳���j���cXV�Dw%��^nK�`�����Y���h���t��Z����T��H[eҴsQ\�&cs���ٻC?�2��#�r�������?y��o�:���_4�j��?�?�8<����ym�8Y�������Z����Ґ9�M.7�=)�{����Tɕ�U٦Nk�L*`S!�q���T�g�⡓�[@%�r��i�P���چ��X�A<�ӣn䵤�� ��f��Çc���@ى�9O�Q��t�h�@x"w�����,�v��g�����p�>��5��������?�wo۰�2��bBl�*�lKZ�zU�^�k��sE�>�^GuV@�@�D�vEj�f�\4+�0��]����-�����V��� i5[3�k�q��aѸ�:F�+R+P-�����pj$j��2�1�׍�41-0���2��2 \/j$C�ip�7Y+j�E��7�,��.��>�H�<�����X����U�M�U=,�&Ȏ
K�N�RC!����Ls����Ҭ���y�q��$�|�{����
a�w|���V�}/wrS5g���C:s�eC�C\�/�Tf�wQ
�/�9٩�8�:XUNN"�Ψrp"qNE����Su9�s<���u�
 �p;M��"X�8GMeNzME�2�;U�@|���{U*Be�zP�"$�o'y�Y�g���� 	���I.�"h�g�� ��@�ɀ��&��\[>DNMH�q�"'�$$r9o��#�$$�8�IU�I�L��n6A"�8'��$�&D�=;�A��(	�u�I��@"� y�#�$DBF.	"hBd�}�MH�Bd��A��_H 
Ѳ���(p�|��PQ�,��j%�˦բC	D��ٮ�.��eK����J�	�-�GUH�e�z�K���`��N5� ������[�Ap,��<�8vE0,�߫:\E0�u���!�"�Y����c�r�(iA0l�ޫ��Be�"u8�d����#�Qؔ��K�� P�a/�K�DPI�|F.�"h��U�ˉ@����Gt������U7�
���)�|)�(8&�[�ٮ`���T���	���Q��PX�݌��,�먛1V��dᨻꪘ*�Kw3��,8&G�Ͳ
���,T]鮨|�^W�+
ؓ�E����Z$��+(C!��'�m�
�P�ݍ�
�P�~��!Tw��</O�y/\�qT��4�PvD�04�VЍ΀H&��ԥWH܏�8����cM�0��x�����L���9�3�or�����zŁǬpJ���3�� o�V�.���*�ʥ�T Q���*�����=(��-���N¤NjhA5��-�$�v���9bP��:��e�
�2�<w� �5���Vq�̼m/��%T��x�g!Q�̫����������@55u�#+��	ہd���i�pt��Уp�O
5Ȭ���X
A(��z�� �&;�.-
��@����]ՠq��Bv_Zv}��t=����;�<��N��k�k������WO���ş��I�}�h��bn-�7O�3F���|Q5��$�R�Xo���d-��4����{ϟ<����K1�4��B�
������7�{ &Y2i�6M�<����W�4��w}���#��n]SѶ(�Xx;&����f��*A�Â7D�����f�������,��߈H�0u^��K�2K��v)z�Ϝ�k��z� &0L��T�D�"�R�8chpjUJ:8}�n���/O�������^v(ޜ??�ͻ\NA�哪SLu���^�k�u��j0��h������]����������/��T�H��I���cK��^�$pH��$�! �Yb� 	 ~�l���pR��T�d�8&�CZ�$�A�bE�Pwmwz�5U*��Nђ)89��St�Yw�n��N�甅���T��\�|��ї��ݾ�K������.o�9��#M�ԗ';���!6��
���`Y�8��A3��5��^kz.�kx���$����06���9�^#���E�.^�r�������\����_�k8?������_󮩅�=�S��x,ي�Y��:��+�Wɼ���y���ޔz"����.ōWL������{�˘x���q`���p��5S���
��t��>������3X�]v�����-���'��e��a����=c��ّ��:����ַ;�ݖ��E]2��	Б�T$9c��҆Mb�M.�.��:��27[�=X�J�>��9��b�Í�g�Ez�2�k��Qly�(v��?{j+���s�EG���7)�^��~��5�o~�5lR���ژe���ҳ�0m��V���; ��Nw�ƼA曃�ְՃx�$�4�T��d�K!����Y�T�i�%_��*6���OO�g��x�yN$�%��tA��"��MPPa e�*�,��.h��$g`]�����*���-`�����M�?4!�a��WI�  �\[��%J��Z@|$�W�:P��,��]����4FN���*��t4A�
m�E������eVr���|�������B�MJ}�᥉�R����������PJ	ZGV4O��ᔷf�����{m2�Z�k����y���Ӷ�mbm���񔒽d�%�����@v�֜�a�ӣ�wkFd�6�ͨ��HЌ@Ͱw�����(�r����A.:���j�7"�J��x�fX�s�ܚqJ�f�n��Π@)~��@��w��h�Sk���\޿`r��7ﷂ������    ���uk���6�C�m�lq�6}��]�uU螬}�SW��C�/u�3$���hA2�xC�~�q�>\��X��%�_A��]���Q�Ki�l�g�^hɥ��A._ʘ?�RM���l��,y��_�ZgK"�D4���b��x�0��0�1	 ����(Z�+��� �E|��Ђ@��N���H�u��Z�����,N���;�!��p	�H�D|`�,�.�%��IȊX��1���,N�"">�8)��D���e+U�RD<=b�;d��H!�4��`L�Oo�7���x���D0iI!�13�,�A �ca����,�z	����,�4���I �'w�Pr�[J�^�b�C����N/�=D<=����O��7��w�x�TA��uW���w�w��^��x�Do� ����(�."�f�H�e�xS�%z˹ s��Dbw��oYğD�(Z��x��.a�-ISD�e�y�Ē�X�e�"�$B�[�t0��Yo���TXd	D�eK��>�񖍉���"��̅�L�E�xǖVqL �[:X����ϖ�\X
��w,��z8	#�%wYoa�p�"^��K!�E�0��xW;�]^63J�+aĳ�$��%	w�<ᦏ�W��dL��&����䠷ߕ �+�p�l�K!�T�*��%���v�$��5��[3fث���]����d����kyZ�0��8A@*�D=F�a�u҃�:~N��%YMVr�c�I��ϲ���̘+X�%2�XR�8�]IoL
D�e�"�@�[�I6�"D���'"޲�OU�X�'=Y)�E|��Ȼ`�OlҊz[Q��%�Y"x�%0�{�tz�D#�%wU�]K*D�g_[�Ә������
���n�y;LD-`.;��Ďow]*j�i��LS!�/lA1����u�ކH��?�s���WQA;R���H ��
?�#5I)�l�g)Ԣh&��
?�#5�BO�~bk� �ڑA �3��$��{z��I��I�V��g�D��.�@�g�A�c,�@�g�*#)"��r �1�j���$�m�_��wU�u	X�W��a�x���L��{z"D|�����@��ݶU��	X�W�wIꥤ�@����U�.���K��">��ī���lf�jQ��2��%��RD|fي��V��/�6Gm4L�x�\�1a��6}]!o�u�� �xD0Ly7P����H4���K�^Sq2�pp�����K�><Cz�e��&��L]�|R{&E"U�L*@
D��V���I����?	s}��z��nO������7�w������������~r���j�<���k���??=lٯ4|�'��[W�rp���t{����}�[���_�-~w�����^#���L��$$7��K�$$�HA��dfҶ���"xDe��2)�0���e eF������8Dyæ߅�TϨ��ЋB~�w�~@/Eq=���2	�"0eҶ	�"Xf����^��U�b�r�L����I���b���j�Eb^��{��H;u����œ�M�50���GЈ�il���zQ٬oWT��QY���7�vT��}7G��F),��mB��8�ʨTI���Y_���n�a�R���(��ч��d��v�AArf$e�J� ���v��@5Rds�6	�"�,CyU�@)_i)+E�H\s�=�"1���YF�HLg��$�LD�9Ym���L��#4"ff���e�6wmhDf��g�QX�e�ȓF��������mN�Z��q��i���ϐnO�\6�c�q�����5���}���TZzX����F�L߻#�2G�Q	P���ʨ̇����a�S/��_Z�zn`U6��_F2�׭���pj��ƍ����Աn-l�,Ê�:>��{��:2�E�2ˊN�Ϲ�q�[3�UFr�AjjaT�"T�?�=��q�q-�M�IÐ���
�bX���n��jMB����2��+���(Л�)Be�T䨨��L�qm����L��L�1tQ��T>џ�Q��(��STH_���WQ-,G�TQ}ӏ�@-t��h@-<��n.f'��+�h@-<����G��n�ӝD�A��K,_�Q������@P���i��-��O;����R˱l�a'Y��/��T�TF�-
fj1OUЛ����ʧ�����{[�)��V��Q��<�ܯ�)1�r����hAO,WI���p�U�.zb�4c�ق��.��3Z�r��=1�e��jGه��(�T���`{M7��T��n��U �Rv�j�3E���Gja�UN7��.���ٌ&Y8��ח1>3�����R��u����P��]�:�q�W�������e��Y� �G���������!ܥ���v��&�x9_��Կ����r���J����Ҽ�ޓ�uD)5~�'~?��?|�c}�B/�����	v[o_�:ns�E
Uym>^jY�mq�������wo���DjKwo��1�4F����m	���r��R["�%m��e�ؿ,���w�����&��~��n@(�� C[<��x����r��
�8���~�%jX q-$�~*����Ws�`	 ���Rw�z���C n�7B�qpM��pw�Ж��Z�8�L�ʠ����������?���秃ͪ���f��=7D�B�a��35�(Z�>��1�Aw��ޝ��˻)e�T�nJA)�ݔ2�R:����}�Q)-�soՎ��m�G깿{[0�tL�F�iM�J�������]�@2Kfm9�ۍ�hb�c��L8Yx�wo$��n�0	���_��?�=���`o�9����'Ck�y����v���/��3'���X=N᜾v�ؓ*��'ne�f�~"\�j��˹T�L�!Ϝ�=+�=����
��!ә���u��0��+Z�Z�Z�����9���I�s��]U�V6Z��@���(G`��ݩZ��V]�9�z*�g
���T�}��W�Z.�|���c��9W[���?�7t�x��i�G;]���͈���!�/��q�4?�HS���Ňdb�@r3�M����$�) ��<C��d�����ĖDr���4�{�q�@*�#�2�@�fӰ�/�*ؔX<x����F����$�JB��&�ȭ��i�Q�&Ј����{I��A
�@�H����㩂F��|o�#$jTA#\e6D�Da+׈lȦp�./�N��HH�&٬!&���0��py� �)0���HH���v��5"g���4B��ɀFx�#�%-�aSX��=Ԉ�"W77J��n�����v/��[��]\ q���"�� ��mʕl�j�)�G�l���J �l��K�Ovz1:�l��@JD�y��MH�H^��RX���(sC70dAb^ 9�N��td�вD:�&��H@��&m����E	ټ���2�-` �V�v���Fai�r�Ḑ�'���-H.#(87�E�L�f�";$�H���B6�<�(k�l fN����E9�pH����t��zaz��K@J����$%e e���L={��zO:NR� �s6P���R��w�Hz��N-iH.<� �4j/K�䩢���̹�-S^)��ϲ�㚓���$�~�m#�s	�0��fU!=	,��E�k����S��q0������د� =�E�vMl�}TkيXw.��b�(���'��@8jk ��WE9�D�@mS��4��J�Mb>)��_든6�y���k��6�M�f �9(HLb+�ê�
N�^���(��f,ٶ��ܫ&󭜁��-"h��Tm�O%N���0�>)�]F���M��`]T�~�,��_#��*;[���$XUv^�S^�GXUV� ^IIH�\W�~��;��e_$�;����0���H�wRY����j�a6���{'���j$�	�lӈ��xJpfc����xJp�kxM��YuJP�aH#ܔK��<���TC�i��\�{K3:�ET}�����a�bx݂�g��0�:g��na�3CՇ�G���ag5�c7ZE��c�Q*ӡa�H�A��aZ A    ��^�N��O�/�d��+϶2����ek�d9�=\���@�Y�QVΊ�z4�
	�U�סz4f�{bߓ�P#��m��"���i��9�	5��_���F�S=��T�kH���*�M��@#
�Uđ+<}���X�zF|�$$A�h,l=#ۀ �F��'�P=_�(�P=�ܪ\�գ��U�� `���F������p�-;��%O^&�'�.o6>�`�����/Ͽ=����������ο:�Kk�U;�~jA����:զݣ]S����_߳5�nZ��q͗��{���W�!4�﨤�6��e�]S���U/���\����o�Wڅ�*}|<>�����*����V����������n���E�eJt�/�9�;���ec9�z��� �ҧu�����I��ٔ�y��{Ϛ�xy*o%X%Xٚ��l���H쥼Z��u`��������T�JTǨFy�2����A^e_�S��'��'�[�;h���d6��3!p�3׺]� ��`�@�D�)�&iz��H�H}�Q%Y 9f�A��4� =�����oY�8yy��_$`�\Ȣ�NnQ�X�"�F�ݾ�`Sf6eeREөxHG)-�RNd���w7}����B
�T'�(��f{�����![�M��e���P-y�a/���wi��M+��^�'�ퟛЌ,ZQ����\+��9.�B8��A7�\ R"�Af��L������B����2�*�I�$�\L�պ����*��2�I�&o���&��M0�������7�w�(�����0��l^n��z��!�(��pT���x~$�	�V4�lny���o�ї��̏n[ߟ�n�i	�x_��ʽ\�9�l�}�Mh���W�Մ�����ՄMHԄd�ՄʛP=5!\����kB�vp�&Xp��|a�&8�ބx�&xhB�&����`n�4�أPm[3�7k`~j�����ߍ���2i��;E����ٵq��A��P���؟K-�.h���x�������m�����������������L=�#�7��efn�5ٕ�]���~!z.Ka_;�l6� ��]侼�����:��K�J�~��I�^�m�yY���]���Y݅�!}�r�\��E��.���2�(�{�&��0�� �u��<5A����@)[�8�.���Iy�2�`�A%]P� K]WzU�&����v����o�]Wur��1Ks�Mt������!����P,a2�l51�c��M���	��U;- &1�j�E����r5L�4��ɀ��41�&.[s�D��#yz��0�a�:��U 0�P�-an*P�/��M�b��:�{��iT ��i���ك5n��Mu5kP��8MȠ�ō׌�*@���,w� T ����q*�Xx�!O[
$�~��0T �iMS�����Ӝo
��y��
�"봨:6���k��,�GM�,�cz?�4m���K����Y2`�B�=m S �5��� �&�9�T�Ȭ��j������z�0�qS=`Xf��i\*�,�:]�e\ִ
*�7�o�T��\��N3娠�0�T�4P�<9�)Sr��iT 3�>*�M1��T`����h�aǦP�289���i���n�,���ڴ@�N�,n��|S�m�N�7��T`�<��]�]U�:���L)�[C������U\�+�ʒ[��iV��������ccaEP�F��T��͞VS�,���-��br[l��}��VS�,�T�/`Wk���3�Q�U�m�X���XS�5�q�,`*sō���x66;U�L`ţ��`H�w��� &r�U�e����y�4�8P�Hb�K��F��\ 2�I�)�`g;լ�U���.���!(�i!h�<���7M��df�`5��\�<�A�(�@.�=�FS�<�Уj�:6�/@O��NSܹ-rz��a�"��A����Q<���e�h�7W���*�� *P�F3�����]�\�P�²N���T���1��Z (LN��Z (|��9�P��֞F3<�@akO�)6T���|1`kO34,�@�}���im	��@e�9{F���AsQx�#Ln*U�/]\K�m�Ö�f��I��3���l����C��{O���&��)���k|��~�H� GH�r�dހ�\����(ЀJ跒�р��=A���p�k�}�P�׬�� aH(���{4����>���	��O��O��k�{4 ��2�W��� ���f���W�P���~s�>�|���ni���6)!̄�S[h�'B�;\��D�26��]F�R��āL�|<�ZZ��)�:&~zQ%�xϳ\�3�e1d�G�	��&Ɓ5�����0�k�vJ�^�\A�Tg��:�d���7
ʥ6s�D)��K=��x�n��f�0�fU��
=L�c�8��Lu�?���O]���m��M����>~�,7���+��Kc���l�OG���K��	���4@*`�S��/5LU�LUNY1܋�B��ȩ�T66���R�Дy+��S��gK !$��(N�2���5�9��)�*�F�Է$��(�a��؀����i��)~�E͚
P���&4`�`阪�4`��͸���Sxf�i`��tr��Yl\�O�X�aǔ���'�U]���*=g�|�ĥ�t�K	����,Iz��� =H�9^:d�� I�@�T�I�]^ͻ�� a�պ�N����� �C*x�����y:��A0�#E|P�@��d���g�e]"~.�nI[��m����|�/_b�Ë��@�'�V<".��Q��ǣ���ρ!���B�g����A �3=���6��v�%�[����4f��Ӣ@�'&���jo5Hl�BG����5���$P�� ӹ�����āD�j�Ru� ��x��5z��n��=���ZB[�AplU���A���v��h����( �+@��f[��qS �fέb�T�D�K��s����2{�����[@�`�	�D2����^oܽ�˝0E��
��Sx�y�_;�5�	 ̻�¡$"�r���D<��N�0I 񖻗p ��x��^/!󼻄�qI���Y��`��l���/@�{>�K�k~�|����e�I+�$��Ƃ�v��ۯ�z� �wl�#����e������ex}�(�/I<F���0����k}>;:5����Ϭ��J,�[�w���u�~cGo.B�W�#^�/C �+K��pF�_�̿���-P���^:�͔]s,W��ԯ��k�!��݄U>��b6�x�S�r�����@Ǿ/�js!�O����J]g�,r��1J�����@��u@�@N�����2(rP[̠��_�e2mΟ���������O�e&�t6\����8OO:�������>s�����������|�ŻM��ȣU�_���)�2�#']P��G�� �Y�׍��h��F�".ƑE����1�|R��A�"��hX)�hFd[���!� ÈEC��A$"��QY$2�Dd��WS�zY^�,L�"V֋��X@/���-�t���l�`����"S�{ԋE�E O?����e��u�!8��L_��t��J�q�*�IN���zQ�OUTA$�e ݥB�(̢��z"Q(M:)��D���SNe+�D1,��u�
"Qؒ{0�X�:H*2[����@ra���`Xr���V��v�1n'���L���3�/a���k?oa�����E
�J�@AE�x�.\Xh�J�z�����;�9)�n�_i����Q�53'��g#��O����8&%QU���W y��$�B3K���F�@�-�.��h�]R������[u��n�yi|pY������s���_�Ҏ�2��Z+�M`�!K�zbe��X� �V��J�'��5�O�\����͛�q�g��q���F�W��:�ܧ�l��4��_ 9�I��dS'-�$Y y"�IH�H{m��e��=N    H���6)r��DR���B��O.)3��& 1��2߻|�TB����e�5{s���tb��1�)�O${�)�uȱA����7�>�������~��ͭ�c���5�ƒ��6v4X�-hp&�����w@J���)�)�@
��mS�$og��h���D㔀dfR��d�9�UFRV�3[�#|���o����e��%���u3�L�"�������QYҦM��#Q��+rRZ^�H:
�;��&@ґ)�m�I�tdJ�g�5�"@ґ3#)S��c�gh���MF��#3��l�c�E�y�,ɔX��D�E�%�Ҩ�@Ԋ</²$�hҞ|#����<�FP�`��Q�&P�Ģ)i�"���ʓo�H�˓���B$���łpƈ��m'h+Q����ہ�IDJ��f��Q�
i��	"P4m�AFB�Hl��m�Mہ�VF�E�{�����ׄ
���{�qAQ�W��^�<Sk���ж/��C��'5�{(�9�O���te�n��R�l_�����ق�yZh(��:��+��g��?��@j�4����lK��O�?;v�ɛ�����Y��O�����j?���_��m	Ԗ�����y�[2�s���SK��P˴+s_�w��f�rvؽZ,f	fVp�0�`+X�!J+E��S8���v9kT���l��r7��`�cV,�S�,s �ۯ � s�?gP�LA=}$V
���`(H��uX�So�4���ә��,M@��	��
av��^���^������j��װ�B��u�X	;�Z`řU���}��a`�y�x�-�<�X�sC���~z�M��������g%`b�!�(��`���PR�y�a�*�����~�\QC,YU�����������r�leFi��5XefmC!�܁�63��[X�a�b��9s!��Ű�ہ9S�Ű�۱iL։�x6�\W/�.[�[�~�7
��h�^��[�Ĭ�uK�}�K9�j�f�}b�y}����{�n,[�@��U]����M�����؄<�b��@6���q�_d�l��K�E����KL)t#��^��!��lF>��9-�BV_3[�z��y���G���Pԗ�ց`x&Yy�@-<S���=a��@-<�ދ>��3��A��@.<����@/<Ӌ��k಄�EՍ,��Ea ]�<j�A�ųs����M֏�eK�_nK��O_*p;��{�d�?�ἥ�g������ޣ�ٙv;������Ҕ���23�����^F%�J��*G�2��>l������������O�_��7�L��U�M\P������(W�a?[���KK_��R�:��y�*)�+��0��;i�$�aJd{�A��v^���L�d�Ôd�e��Z��X:������b��X:ms�c���XZ�����2�cZ�����)�0��Tp[#���~�E\�xvм$9�a�g�C=�a��G#�{�⒓n���яy�n���>˶��u�)�x�[��F��ʊ+�˅%HGee#�n�`1S�2?ʐS�7��m	�G(�v^Ƕ�eNX�oDO�a$v]H�*@��dX:s������u]6Y���"Bh�4"��:́�X��G�lU2��\\2�H�X&7JZ��e	UQ�C�8�ʮ�+�!����2���9�(�S�ΞX��zp$�ALM4�,&X�ꨢ#EI|:�A*(��Ax&��[��Th��I��2�?�d6B�ԣ0�Ŕ��s��IK!�#�2���.���g�����(����Vb��T���Q�Y��f�L����^��
�Df2�lS��/G"�h� ��~Y(�r��.�mS �em9/��DY��!�FZPHX�:m�3X]�����ŝ�BY��9�\Eza���+jq��2�H1��61%�B�����2Sv�g�@K�-|�CWX[�<�]�Թ��Lq����0��{`O75�a� ُߨX6����p0�-�XV �^Q���M��
Է&�;%�l�W��r��yL��=�)�����{��U �_4[rDg0�a��h5"�p�����ύ��Zڛtw]١����2w]�Q�x��2�/��sw7��?ds� l�,�.{�]�,����b����k�Qt���C�xԟ2���$��=�QK�hQ<X����wWC,�K�2e1�`���dHN��Nd�Wж	
�#�qW^�;���(�_Q����`��K�i~8;���d�ٴ���B���Y��_���} w)Bu}��;_ؘ�9����@��3�喝K��� ;�鐧�|���M�ɖI��``�`�`�U!�T��9T�*d�~�"��!�ƕ�{��Kѐ_�B.%��Y�y������ ���^A=�&�(��W f	vX�բx���iv��(L-�t[*,��� ��+�1�Z�94�n.s�鳥K��΃LDr󴕸yZs}�v������N(�bR9y�˥����8% 9f�6)�3��'#q�0�l�V���Ddلr�JdI�����e��o �r0��M��}���u��YQ� ���|��&�@d�y^��@ rf$m�@ 2�a��F��QIy� ����DN����%�2BQHȳ(W��Y��ӯ��¥ܬmR -*L���1̱�UW�c�g��n�3��&5�z .��EA:^+n��	��L�Ҕ\JJ�C��Hr�D� ������%�̖��6q��w���S�E�\/AQSr�7�>d��|E�z ��� U"�0�Bd"��M��$�^�E��@"29y�΃RR�,"e�?��{w"(�K'�)7C���I�&H#�e��i����iB�0� %��'Y;eP����+kQ�"���XF�`3{�6	�3��IR��،��"�DO>	Z+AX�Z����D���`��l˨�/5
�D`;�~.7*�` �M��=>��[p[�%~�%R����Z���UN(��EP&�M���=h�����8hoTU$�
�Ad��X�i{l]�3�<p%�6�U�� Tl׈jX<�.m*`�Q�>>��lɦ���4�1�����@#��i���F(�x�FH�c�$Ԉ�<b�����@6Q�">��:��0�M���7p��v�� H�z�@QY�|v�nT�
i�T�d� ��%*;���	�%*[�K���$P��Uz�'�&���`M��B'� �MN�c�I(,)��+R�P ���.x���%`�sV��[H!�q���I�B���/�H�%
;H�$[-���';;�.�d{|�Vky)��y�B�����|��������$�y��1���-S�^&춇ԒJ�d�Viy��F�u�V��ߊ-�0��U����+�̯ +ּr�F�k?\^�#�w(/����r��2��
�1�]^���,�ݣj�k죾k@�e)��P��"6�2�JWް�3����OPzY
�KW.:�PzY
[�(yz�b����O:iyæ��p��2h�cQp���L�cQ�Mp�QK�t����-�FL���8r��zѦ$&��-`1)��Y���|s���&F�nՋ�	V ��@��T|@��d����Ȧ���B*���{�	S���ʞ�//�gIy����I{k1���i���"	5��ʇ�/+��ji$�P~iY���̥ީ���K�*����v��vKw+�n� Ӳ����EC5��݂�;�� �av5+_��	����4���Z(�%��'}"�2��L�	#	_�´��~'_HJX=aZVr��W��@���p'?쐍Vi�Ś�"*0�a�r�9CF}����<dEc���]��G}��X�M�Wv�ƙ���� c���
0�7N*q(�cZ���׭��P�i�!�^��IA�Q�7��"�bZv�r�@:NՂu����*T���J���Ӳ�l{�zo�C-�e���C7��z��מ<�b�Ug���Wf�ܸ�W��|�	�Av��d�/(,��y��>�C�\u_e�P�i����<yYŘ��7�V���,�1��3g�(��7l=c�ρ�$����@-,Ep��$&�VX
�H�FH �����{(ƴ�y�@-�؆Z�����k
	`�VZ	Ij1�'�o���    ���D�H�6�D�|����Ŵ�%�,Z%���{�)+_�P�iMa��z�-@-f�R�<9T�f� ���UH����ȃ��	��8���[�eZ���N^k*���t�k�� �ʴ�=����\�Hl�Lz�/a2A�(`�/e��bQߩV�ɴ�m��\�^��e�a�=)�f����h�A�O0(�쟝�A�F��$[�uG������"i��B�+�	��d���t����>���|϶�^�g{��I��?����g���T�
��ۼ�@9BM�7�Z��qp��|���O��Q�=��7'Τź�!�z+=���`n���>>���\���Imd?}�IS�߾��&u���O�������巟����Z������Y�b�5�7I� �N�������/߼���_��8��Mk��$�����߼�����˷��5��&��9�^�
�,S˦��?�eZV�e��-�T��-�Բ�Z�e���wӭe��}�e�ֲ�v��>��2G-;=�eZ���̣G3B�����}ƥ�*��x���$a�qi*�R��N�\����ܜ"���L�&�O�<��Ѹ��J������+4�P����H��%lP[ɷn�UkRk��.2@�9U���`iI�Fq�I7��E����A��
a�<� ��rZ�#Z*�㧵�B y�LO��w��yCHyN1�de��U�t�Q@Ł\T�Q$,8&�1?��9Pv�ŵ&���X��5F�˱��u�4�.Ǣm O��@�,%q���R6�q#��2��4D�&6kx5(�e��]a�(�eYy]��re�\�5l�jԟT�7��v4�:�`1G�k��Y�Y�Z����~���H!�ҟ@��[}��-�"%6���� �D�VDK�At-�Ҕ]SmH_�Ԩ>h)�!WK�=�5�җ��5h(}l�e�y&��E���4�����Uڃ�4�}��
�C�|�e�yH_d�70�g)���E�k9����zw`�Fӑ
�Vd�5��Wm�Zd�6�k��L��T�Xb��#߂��r��uuL�"�1�[x,wLr��4�0YW��c��UEe��LgW8�Mt�zz��`%�l�p��j�2�
K�50\&]&��	�j��T'�n�-�j���Á�^�AD��4��
"iϏ���1� v����Fc�FҞ��r������I�'ӏ��Wǂu�����D5L���Z4�����cvꢁ��D�K��}�u�

�=�^����$(x��[[��ͫ��B��3�G��-���y���l�R H�bZ�JR�4(LL�����P��Y����v���DgK-�J��P�#��"WN�"rO���c�^�"r��	�:-�U?[����r�踐�y���;������d-��8;r���T�c6M��\�d֠��䢃MS��]>�#jh��Q��NN��5�!����2�d��.5l[j��Wk����W��u�)A���1� �d�'���� (!*��u�pO�Az�I����A0���>lͯ�>�=����s��zK,�F�>z%7]�7�X�v�V���AQ����<�P��L�"'��c�n��ҥ�ǌG@�eG�5T�����Z)���*;z(�Qm�qaG�9U�7^����A�j�P�Y���S�E����˅��h��B��n�wm���{)������~�Wo?yz���s#�%s��K>�d�#R��m�ksk�#�Y��:��xj�#.���]�ks5��,��2ϵ9��sxH�hNb�yH�Dޜ�"k?�;׫�/?qo���07��&�`��Yf�Cƽ��,*����A/�	3�!g��\��2c�����h�I��,��2���h�o�?�̾n���������6_���=.ȟ��7���=ȟɬ9���gH��#.��g"k�CzҐH�!�PkJ�g�yH���}b��?\�m`�PG�&��g���QyHB������qw|�"?� [C�aDز�!� ز�!gDز�q�`������lz:=�w ��l�>=�w@u¡��Vs
�
0�q�����Y�PeG�e�CT�6�>�w@�[��;�ʎMC�5TٱI"?�9�ʎ-��CTٱ��lt�{`\��UA�]f[!���������rq9X�T�ob<?�J��iݣ���V��e���a�@�x��(9-�^"v�@���-�*7pWn���VC���
4��A��ܝJ�$�=��&�=�T�������2��u�0��Z2(�l'l`�e���B���׳RaB:pQr�~ �-Lt��{�{Z�0����÷>�-3O1|�㍣F�M���K[�	n\yv��>b�+�5�T��?�]�׬Ra�?p7}���6K����2g����������i����:oӦ���>~�s9k� ����Hp�+&Z�ܔ,
�a���a��Z���$��-����x
�aّ���#&���m��LN+Г�f�u��*�
��hp/+��zr,�-���97��ʖ���5y��\ٲY{��]>B��Z��a� �~�8��X�2�z��k��ʆ�"O�����0=3k�@��S�s$����lH��
;	�Se�m�@�ؽƺ�V�M�̮-�_�I�l�0��r.�V��i,��7��@̯�2�>����_�Jp�*Q���\ߔ����T�|}�[�I���ͅ���n���h��n���כ�0���~��kS��v�5�7���(O���X�p�(Q���<$��F�Zd�؟��`�Sf9��֐�݀��i�%��vk�X�=�����;�I�䘖��f�/�$Ǵd �|q'9�%k9��1-($��$h�#-9��+�w���hkx	h�����k�y	i�a��4b^RX�����Xm`Fl[¯ƒ�l��ȭ���ɷ\�z7=�4{s�-l���%����e�?9�Q�-���ο��z[�J�S�OԶN����T	?QK��}�Kp	��+K���b�/��R�G��W�beS��o�$�Q�l���(������>�K�j'�-�v��N��%Ò�m�S 	n��ʒ���J�M�kI�g�be=�«�	>+��ԁ�T9R�tr�jFN���0�[c�>�ӳ5���@�0�Z#�θ�e����"SA-I�KVX �E�Xj�B�_�������X��OJ�6�Э�M���I��8ts@�&A���$Ow��ı��I��~T����;;)�iǡ�DBh{��8t'P�I�.��K��;��1z[Af;\�H�l|U�����$��q����K&�>�{�q���k�n E��ǡ[nBRb���Nެ�L�֨����	v��Iޖ`O��*�2ޖ`O�����Uv��{��>�N!�l{��>x�*�ŉ����y���D�T�c�#��,��@��&g�7ؤ;0@���d�.�=K[�&.N�z:��_te��)�8�p��g��@�!�႒e��6A�K�^�1m�Ł�V	{���Z�-l_�D��k�W R`A���޳��(K�n��4.	��`��@�
,����4����z��T�w>�v�=��R`K���K9�(�%�
;n��Sdz4�"�, j�cöW�lOB�Q��PGXz4�^��:º�1�η��~����9�`:��WW�S������G�������gO�i��oο8�����oR�����������ވ
�(Ԉ|�Fܪ�/��Yi�@?X�Q��;6�A#h8��c#<4"SO����5�ܱ�ᎍH��s��1�؈=�B4ݱ������TL��~!P1�;6�9��~�P1�O�;6��D��p�b���F�����%5�;�(�e=�����,D�{ӳ�8ݱ����#��1#(�a>a��Ӱ萼V��PLæ�;��Pz��ӳ�wl(�a���c#P1�Tn������E�{�\*�/��4�4%n[��齕�6�䟭��\��}���V��;�����ߞ|�����n�
�tź����հ���K������rX��,W�ykNq�    MR����k�"XFc6%ڰ0��2-4�a���B����er* �1��AmX�8#�߭��/��oW�
�|�++tc�� �� ə`+xcFI� +uI���FP�DqVV��
�ؘ�э� ��,�0yfPO��Ƭ��xR��L
rr�2���{���T�k�P��g`��$��|��}&�C����dV��R˱���$�<��^�x�E���D�a��L�꽗�&"%u�Ȝԫ/�2=)�J*`��m
N�T�&�=��� �|�i�SE��ދI��8�W6�|/h�<��!���UЈL���}�^4�~�\3[̩M�a�F2���%����Z�����LK@+Ds��-ٖA��]�s/ (�����u�T���^���6M�ڰ�a��g˶��|.���Qڍ4h�ב�Lܜ������ߜ�����ߞ�K��O�W/t�M�q6ոL-�U�7S�:�"r[fS'}�6�&1=c�NY.����9��'�H,&,l�@c���,K=f����F,���Y��T~��`��lH��ճ�n��`	c
Y�BP[P�ɲ�̢��I�^��i����~�J�	M_ݯ/�b�M��f��BM��YA&,hR�Tĭ�XФJ����ƺ��Oʷ��}�������N.����s�gxT�����8�a�ΰ�)���T�HHi&M��f9�Q��
0�@}8�z\��ЏO�J��p�'�b�S��ڿ������ÿ9�����������nUk���mp�c�^GT6�}�����}��;jD����͢K�7���~�ķ3C�V�tc�=V�YS\�v���xYn��y�0o 6��Uc�]�g���5�Wc�q����;0�l`��00G��, �l��D���,ݰ�`�,� ��C��"��e��l�11;�`Y q$ v��� �,[!�(H��f�j�4�6��XyL�k�Â{Џ6��v���.��ּٮ�#�|��bWP� �G�S���g(����_������Z2l�������`��%Ǐ���C?׉����+�,X��L�WL��#+�Z���a�R�o��H�a��zI�[��!�0�|qa��}̫�s�Έ��U�r��Ǽu�`Rn�h˟����dB�x$Bu&�7Ο���;�dR�x6�p[�M0�<h�b�)�������(u9
�@(�J�Q\6h������>���7�^z�r��������4=0<����ؒ �W!M�����W�U5�4^i>�ˎu�T���yr�{���߹��"������r�j�v��1�_�>>�2�M�
���I3S��,�T��`a^=��N��2K��`����V)i�n +[�#�*��
�bVV�e���LGcڰ0G��`E� ���V�ʰ
�ɲ2f��*H�1�3�e� ���)�
HA�
qV@A)H^!�
(H �+�~�� e,�e0P�HR�pP�Hq��jP�H
RƦ����@�����,��T�A�w+���� ���x[�y�� �D�1���"�2��pPCB\׀���:&�2(�!!ޯa(��\��Հ�X���S(�gٕ��T
bi�v�iA5� �čM12� �泝~�]� ��Qv�	O5� TQ��9H5� t"Wvk�>(ɕ�~R(�ɕ�
qfq�⬮0f�%�+t�E�nܮ�)�Th���|\6�~�~�v���w�?9>]��d�9�p�S��������i_H�~�@��鷧g1&�.�i��a~����D�~�}o��|g.������m���~���U������M�M�/�w}�t<�x��a�g��`9b9}V��Yn�e�ˤ�K���u���`��!�:��<�:��x�������ڶ��8�2�f�\�q���q�������F�>.��
.Agfr�up�%��`Ү~����w�e-��Tb���b���咢 &b��
f���������;̓�D7Ӽ��h��Bs�^��gx��`/�1�D`�w=-)��JX[
����6g(9|��L�e�҂��	�?�41�c�!kz5�&B�U�ɚ���0MLL`.51��2kv��
�昧iv��,-uZd�����J��[�_�跿��R����MM�\��+�k�K�?�����k��Ƕއc/#�"�(�S>���w�e�o�i��9���zb��[?���O��;w�Z_����<=`Yb�O�"�ĺu^���2)��nխJ0Nuf�SQge`�+�!V� ��
�2��7چU`%��}�fE�x{Vq�^{��V�Y~��Y(^��Sg�l8
0�:d�R���^��=�/������-�vB�>"���W�j����'���h .���K&]�������6[~���g�Mi�ՙ��{vr�E�<�s��)��t��ۿ��-�fk����
����@��g K 9m�g���Kװ�c#�vih^��|^�%�:�] 9����Y�y�Tt��)��y����IԚ�3=���&`��;@b�d�6e@Bս6�p5��WT2�`���[ӯ][sMv�ۚl�54���������Q���������O��Z������v�4��O�,�Of�S����@�c���e�)ݚC�DO&�>t	X��$��S"R�zs'�Y(H��
���% 7�W:*�l-1����L%B�~���!k�`q�b3U����~�C�}��?9ܲ!����yu��iN�{y<�^�u��$��-ա$y��6~�����7mĞ
+(O�E{��%
@X@CfY1J���J�_�Aq]g\\�B��q�fi�����U$$��ܺ�*��\o���+p���]�~]AH<y�ޟT{�J����H�'	�
k�b	�F�t��U�{�<�V�*����I�DM�6��"����$6P'qn,�X�1�"��-���N�1�5���E7Sw����P�p��r�4�:c@L
I�i�}@'���1���c�BZ�x���D����e��Z�9����/�����y��c1��}>����Ã�^�r��m/�h��6�p�f�5M+����?7l��G�{&݈������/��5��3��:�ת��U�.�)V�Ax}����QO��A�$^z/��BE�2�ݵ�q��o�����?>�ؿ8����7�g�l�������7����������8�����^�<o��Դݔ,v��>@���D��*m���ˠu� B���sWb~��K��Դ:�����n{���9�����y���E=�yfD濻��=g����ٻ�X]�����CO5�����,�u�'�A��{�=t��'��!}U��y����T���c�V��.��{��b�YY�K�"��aRyUVV��]ګ�
�
���x-�*��!֥�H���,�.�V�,}h�7^�=d\����V߮���^mms����P�v��
��gSҪ@�]}zI�DH<�It����-Z��V���,�Ă{+��>!I܇�|��0�2v�T����� BI��jw !	�&�.��b��Ѳ��ޝ	�~�@��ztH?�'�a��X���g�Q=�
���Σ�y���<Z��4���>����ы'3)+b�A[���5��:�q-\���ktͿ���w����-����M�uX8�g�K���gD�?����q�b��p�����[��(<s,�4�p�Q_ϛ�Jj$W]�fR2࢔�m�֏d���gp��a?���?�Ѻ��?9?��i�-9	8��Y� V���N���;h�*	�y�-C���2�l@��fL��>�� �Lq�f��0=��5���o�_4=����7�/�����>�d�_z��)P�v���&k�9���
�[�x��K�@o�7�P���i��ojA�PZ�X�K�-�Ђ r>?0�W�]���i��jc��9����MΗ/^��N'_:|�A׋�/�w�?�+��~�/6-�(����/Z�Ŭ��~1)���h5~1@��/F�l����~c�*�"ČS��1cb�B�H������}e�{A?���U�o�Q���U    �=�*�u�����&�?>���;�LOS(��~����'mF����������y���ܯ��p��7�x�x4�ZW���ã�_�m�p�%S�?<�zq7����~�����=��~���ԷMٷ��@CT�x�Ibf�-ČFZ����b!f��X[�_��B���/��n��
Ja!ff�~�����>Z�A�����cF��3FAČQ�1#���_������/b�(d .��~xfٟ��Vk�cF��m�yF!
��_x��/�<#���/*�\���h�1@��Gh���`�f��_��F�����<|�!f$���/3>(�L�yF!�3
9n�1�B��
qx����=!�/*�3!�/*Da���
Q*��B�D���0��B�0:h���G��!f�B\G���3b&+�L���
1!f�B�D���,A�T��I��Џ	b�*�c���
ړ f���@�T�I3UA{�3
J� f��/B�$�~�3
ړa��
1�q�Q��1Sb&C���ɘ�i�5ƌ��!f$�
��14Fb&(�������5��1Ԭ�zFr~���3AA�
�LR�1Ԭ@�D�_���
jVp@�!f$'gK�Xa����-�"Č��l�a����-�"ƌBF�Qa�+Č��d�!f���@�$������՘�}�X;1�>\{��y�õ�����3��g.g0f>\͜����f��<��1��L��qP��ǌ�: b�b�(�5������:��+��?�[��1��� �(О�_����g�nu �_�����ᙽ�� n���_���~���g*uݭ`����"ČBųs3
U��A�(T�:1�Pe�Čd����3
�f�A�(��91�P��<Č$�_�E�����/B�HvbFr����3�ݙ�_���� -�"�H�¥�C�(�_;�1��X��=P$�R?8��d ���1��S��[� �$KY�jg$Y��/B�h�#���� ���`�1
VC@�����D�g�]����.�"ƌ��D��{�yF�2�E��n���B5��0�(԰�1�P��f
��.A�(ԇ�1�p_�%���p� 7S�w	cF�ç:��m���'�h.T��rW��]��/w�~���7��T0.�D]@"z��[����d�U"7���9�O%�� ��<��}f�MDH�&x�`��D�`�.���Q�����B�^��tʗm4U@�P�w�r������oħ6h|�o��Y�N?8
��{18�c>|�TT��UPъ̩/��T.��*���B���j��_�|��%/��T�;)X���/N-�� �SGEj�xq�S��6ݫ�!'��3z���n��{a�}��é/�_�T����7���J��<'����@���W��@J�sto@G�}f%o�:b�o3����ə�O#y���}�xo*P_̫��� �>ɶ���Iݼu@������ H�4?��;�6Aߋ�2��J�J�,�н���Y/j���r ����Y�Yx9�~���o��zu;�3���_���nը�Q��MRR�[������m�$�����F�!�mZ'h#@܀[��������֞�$7׷֚��C�In}�<�xjT�;Ƅ��^����SSдz1ؠ���%�	a�Ԁ�����u��,�ݯ�I��d�����c�4��<#]�f찚h���T͑{���Zp�b��=K������Z
�#���k)X���g�`9b�W�:�(o/Ӵ��t-�
� z�tH�D�I�UVp$�FS\�hXA��M�P�p���(^+�\�(��d��	�MI����_�o���\(]��L<o��,W���9�M��������_�����w�9�9#��w3~w���e�|����=3b����������9��~��z�{o��o��/�.���[����x�m<4����~�o��=�]��x[�]��w+�p�xx�w����6��~��w����|�om���o�=ߎxK�=��׿{����q|��~�C���ѡcvK�����m����m����Vw��;��w����얕D[�m�d�����U�9�*rɲ�����n��fís�SZ�D�č~�D��~Og�w�{���[F1F�n�;����]/f��;'����Ή9���Ή9���0�=c�=A��9�ܞY=�����~�s^ً�β���kz�]�������E�����~�Vo��S��xk���O�.wP�����V������wh�9�~��[Vq�B��ww�x{Ǝ�S��x˷s���E�彸~����;���oy7>��;3O�.����om������E��ݞoF>i��ߧ~���n�͈����"��{o�{(�=ě��{(��O�.������8�'�x7N�ou���`��v�Y�����-��g��=����g�L>������n�]�o�q� ޞ�����ɱ�{��6v{�6w{o���m�U�����U��v�/*�T��=c��9p����r�d��x�͛��~j������'w��x�/�:N.y�n�a�8ٍ�t�����m�?�q2v�:N�~���nܡ���O�.O�w���ݵ�Њ����|���������O���~�o>�������7��p�_��y��ï�9|v�������ï>8���w��~�ſ;���?���_���O~����\��������������.�}����o��X��x�;���?�U�~�l��͏浲YWɶ�l��m_˞p
فa�C����`�Gs���㣹9ڔ�����5�����]#�z��*^`Yd��,7Ǳ􍀬�_�����"��̮*fw0��U��I5`8ߌ�@�p�ï}4���J���G�-����G�O!|�ߜ/I�qq7���������鍥o�7��<�����G�}}�s]G+��V2�P�Q��^Hy��h������:���?>�����h�h_�.��(Q��X��&� :ע�
�:i%���0�Ѽ���8^'d�J�i?�� �k��w�1Ȭ��[ow�!KV��v��~2`��"�����O��UL�]��~2�EKk�o�(B�����sG���,�v�÷҇����<��-K��J�2?�9�y8~���uN��u�]ގV�"4K���TC��N�Ig������_�=f����v~4�>�c�:��K�Z�c�Ճ[r��׋���<\]=�:�{p���~ryw?��{�O���8�����=6%��U�l_��o�yC�7W!�=ut�J�>�SD�}��v}n:m��#y<M��A�V�Q� ��"i�f�S�0�W�:ۮ��W�9�E���s���?[~�NMA�X˂o��.��,��߄z���}f�_�v%r>��_��"}Ĉ4��I_��d�x�A�kB�����#bw��޾_��Y����X��U{��X����E��ï�/��tT�P�P���O������o|��V�ԎMʎZ_}��>-D��j�ͬ0-���- !����Eݮ���������h�ްc���(ǲZD�3�����7��~����u���_���7������Og�*�	�S^V�-�������{�P�B�e*W(��cl�4�s*�a�T&Ôc���
���m*e2l
�����g0̔����a��Be2L��0���[)����/ʖ����WPB�	�S�e*��P9C����P�BلʾV>ϒ"�������=���	_���/�^��W�~V��Ku.xJ��W�R�	����B����t0�T�,�o��� �}�|�������2O�ix�T��vr�����3�����Q22Q�i�ᓷ�/�w���i���ʓN1�Y��6�tO��Ji�tQJgH�t��TJWHw��C�)��Yz��M&��w}�$eҤ�+�'��f�y���.Ǣ�S����y�.�����Um��U��E�Z�ZE��.Ru�6�j�j�v���X���Y�Bu��u$��L�W%&��D��`SQb�MMD�	65%&��D��`SQb�M���
�"�(6uͽ.k�I9-��4�J5CUæ�
T    5n�BU3��P���-5�jⵥ��Q�+�&�["�D���&��ڌlR��MC�&���M���D�7�I�75CޔEl2�i�(a`���l�I�3�$Mk�,�׌5���k���W����5]ͯl*����.�(����""f�MY9{�Y�����f�6eQ�T�&����Ml�"6���TOޣ?�l�{]����D_`6��(1�6#$&$F�DM���!�!�5B�X��I4�U`�D�x�r��`T���h���*Ru�,&��)�����hw�,&�έ�ù�R�&�)���XN�h9�`SRQ˩$��ؔD���MIĦ6%�ؔDlj`S���M�xm�����ME�#6�I���7�6":��]9Gd����L�!�qD���8�Wmw��6�;��U�k:Նp��jC��M��JX��j_b�M�'K�P���=T°dՆ0,٣��K�p�`���`���lrQ.AK�����!2G�I6��K�P���=T�!�dծ4,�Ceˀ%{�v�a�*�,�C�+�i��JwZ�E�ҝ�lѮt�%[dU�d��%:-ٮɛ:-٢��NK�hW�Ӓ-ڕ�dѮt�%[�+�i��JwZ�E�ҝ�lѮt7�7��DK�hW��&��^xQ��lWE��D+�K��V���l�J�Ӓ�z��d�N:-٪&㜮��HKv��l�~S�%���5Z�]�iɮ"6ђ]El�%���K���wX���,���h�~geMn�^h�%Kv��1�*E�XI�8�X����՚j��\���ԑ�WPG5_��=T�&:�U�5�C5_�񭚯����NǷ��0�C�ڥ;3"�{�DM�:�C԰���=D��:ߣ����5�p|Q�����;�y�h���o�����-��t8����_o�Z^<6��uy��K�Ǌ�}%֥�-��ŀD@�jou��'HD��n��X�������$"�ݽB"GH���]�J �G@Uz�nyP���>!�#A""��A""�G�DDt�����vp����=8w���:��Qhk2wODw������q1�9".&�;G����Nq1�6"������d��.&�"`�	����%�����>����}���%��hX\K���s%1��h1]KD��;�����G@N{t;�%"��FT�]��z���F �0wא���]# b��k@�y� �uHD İ�. 1��KD�e��% ��"^wFt���Ό�w��.ѝ�%"�3��C^7�;GDwFt��Μ���Vk���(��GĬW�����(���.���=�׍�n!w��nS���_��Wsw�x���Ы��#B�b���@t{ĔT��G�����#�����W�"����w�����vD�GD�#�="�������#���	�s��ι;�.�!�3�8�>�#Z'��jp��l?6�YB��,!ۏn��UR��%d��ZY%���BVI��Ef�j!���Ef�j!�0��Ef�j��A�Z�afЫa���Ef�j-�03�U�0�x�Z�V0�j-$ɁW�E��j=¤1?�1�?�r*�]8$BF[�j�����ޗ�:αq�E�*p�������#�m�Vu��Cvs�hkv�G[���8�Z��l���B�t�����hk�ؙ��D�L���ل��E��&m=�d���"��'m-�V3�hk��	G[���L8�Z��f���"l5��a��p��[̈́��EYO8�Z��f���"����a����y��[̈́��E�j&m-�V3�hk5���q>0�hk3��Q13�hk3��Q13�hk��	G[�8���ݸB�{owG[���L8�Z��f���"l5�p��p���"l5������	G[���L8�ZDe����E�j&m-��b���"l5��a��p��[̈́��E�j&m-�V3+���]��GDwetG$�p��_ެ��#���!��$�C7�}����/?1�)mQ}�hgQ{ō��Q��%,D�B�#$5B�A�DHtH��	����H�~o�q1#$�,Q	K��A��*���1�{č1�C�>E|C����o���"�!�SD����P�	�M�jx�#�q��-
�q�~v��Qc���O˂9=���Oƛe�~r�l���,�����O^�P�'�G=�
�,Ru�����z��$R툐)RP"Չ�i�A3�;��7�Z� �c�� yj�=1��騸'�{rZ�`�H"k��k k�r`��ON�K�YVOm��~z����?8�����������_}����%G��&..��&���p��mVє:+��T}��D�DҒD�DҒD����%��$M%%,��-��U��$Yd,�y�j�����R�L��*)�ME¦��T$l*)�ME¦��T$l*)�ME�&���Mƽ^�l*�x5�I�
6Umͦ�$9�
6�Jl�"�TE6���8���*�p����l�"g��D���&3�&�9lʪ'6��Ml2�2�d"6��Dl*`���T�����M�x-d�Ju�&Se0�AUD�ҡ*�DPUQbBUD���*�D5��(Q3TE�Zy���׊{��*��D�Z�T��
6�VWlR��*ؤZ]9ؤZ]9ؤZ]9ؤ�%�@U�N6�T��.ʛl*U�����`S���."b�����=[��M]D�6uؤ1.�d�([k`SS��MMĦ65�`��&b���Dl�`S���MMĦ65�:ؤ:��d�([�)�4��E�k:a�6ծt�T��lR�J�I�+=�&ծ� �TN�6��\lR�]�I�
6�Nؤq|.�`���Y��T�OX�M���`���	_���M�����I_�j��pS�4&�$"��~9YQ�+�$r�|�&r�|�&r�|�&r�|�&r�Z�N�a�/�D�VKd�*r���!�%�өT��,z���[�	�p�"6�nY�&��-��_�e���,b|�59�٤RE�$���~V��������t��_TE���/��,�2�M��e4(��y���nPU��UU�M*J�M"��I䂴�f����6�vC��M�x-`�ȡml� ��M"��I䂴6�\�V�&��*�$rAZE�$rAZ�D.H�/\t�lu�&�"|�I�4�ʼI5����J}�SD�§���O���"��>E�	���3�/|���yN'����""�>U�l"6�>Dlj�o�+}�CĦ��I�K�.��3��5mx���i�[��pM�bk:����t"��5��D�@�`��ik:���:�$r��u���ֱߤ��C�n��+٤R���l�qX�Du6�&Q��IT�alU�� �T{0cͦ!��f{�ݐ��&�n� �DD`�j7d�M�ݐ�0ӉF��T�!�lR�+ؤ��țT�!�9Q=a�I�2�&U����t�������� y�'����<�_>;���6�K���/����ڧ�+���_u���mS���G-[i�uN��]���b��]��Ï�R�_}p���|�ſ;�拿����������������{�w��\�_,/�w���?~���k�x�_�5^w���9�׏�v���:����,���/�?����^Fϧ����e�����,�Ǉ]�����2���;�׵�S��_�9�&��i�AU �ԑAh��Ӏ�&[�iBU�^�9�&[�F/�h4Y��&[�V��ɖ��� �f�ޖȿ��l�dK��&�/;Ã�s�L��K��E���tQǛ�*�	Ve�M��AuY�y���Z�]�e-Ӄ.겖�AuY���wQ�D���Z���z
ez�E]�2=袾���K�M̛T��n�l�	�]����I�.��M�D�\���%�7yR��M�T�D��S�K�7yR����r	�&O��zR��lR��M�\���%�AO�\�$:����֯�'�=�"�O�=��>y�AW�+�$��d'�DO�ɓ��F�=��T��M�9�$�w��AO��>�$����'""z���Qeޤ�W�I��'w��Dc�ɓ�    �Ofor��1�7yRͯly3z�'��1Ã�D�ǌ��I�}��M�T���M�D�ǌ��I�B̃�M�\�ɓ�!��$"�`�$�g�<~�i�=����Uv���^>��EcQ����_>|��wv��5,�;���W�qم�]c�5ι��s�1s�}����z�wװ�;O%d\�]���5F��4.5U�kԕF�1�8�1�1bp�h��|���u�_z�쮱��>"�yI�8��9{w[k��y�W%�G�KB�����>�="KZ�y>�v�]c��b�q2G[�y*!�a�8�%d\�:�s�yV��=$m�5f��:�����5�q^f��:Ϋ�<�u�{���8/#d��	�<$g��8���1G��`^�y�!9C^���	����w��>b��:�{�>C�X��̵y�)d�\
��BxU�q~�'��F��a{A���ܧT�!1X�>�q�c�9�<Ǽs�σby{L.Z�q>b�Ċ8/!yI�>\�~I��81yb]�������8?U|�췗ڠ2�������Z���;a�'�=�}8����������/ 8s�q9����)X9�)?<U���WkO�"�$K��7,��?���e�Z��֮��O�ؒ�=�v�y_��ɮ��Ϸ�����`ן����Ϗ��O�����Ϸ�_���x��V/��<^ߧ�Ϙ=;�ʮT�P.B��*T�Pv��C�	���P�Cy
��Y9�'��c��a±���*��±���*۝3�26��`XU*�aU��O����,7�ނdge�\��7��?ڤ�g��E�O�{2g���nf����(��%S ӣd*dZ��Cƣd�;�%`-J��nJ�̚^���D=�I
�ɀ3
��QC`�3*n&(0�(0}�9j"��F�t�g�݀9,n�䠸�)A&(nj2���2d�³����B&h���7AyZMw&C
��51�@M�@����%�
�(
(P�(`�@���U��aw
䨸1��V�ɑV.�ֿ�;��vb�gO�G�݉|��˲�?K���wv'��)�ѱi��,�W��	��L�7��"s6K^o���Ft�g売�ў����I�\�\���M���-j 7D�r w<�"T&����\ ��Be �	C� Xgc�H�:��R)X�j��#��O��Ce+}��Ԕ�%3�2#E� E]���#R��V�L����d�(��8Oײ����$S�u������=�4�D������F�	���q��2v���N��ųg�"S�q s��^e�	I��A�F�d�D��s?�G�%S1��c��(���)&��n�S2;l�8�pN"�D8�dZ¨Q2 B�Ck B�ݜ��?`�N_.�WG��������O㎞Օr*;��P�Ay
��Z���1��r*O(��ѳ�z�.T6ܳ	�3�
��0�{&Äc��a����rl�a¹��a���a�c�aY8c2LH���0''�}d��1��ʞ���Q�k��!Rv('�r�ӞB��!TP�B�	�S�	#L�l��*T�k�,��I�e�2&�;g�"e0̄$�d�pƘ`�)�6f���ӑ���ᵲ.'���n~�����Oʧ��k��.�Z��k�{�lE~�h	��h��%Bb@"GHLHX���r�(1"$N����%������_%�[0��Ǐ��-k����@��N�F�!:4�m-:E���N�Ft�E]�N�Z��6��g7�U�jR����f�5�7�H.z� �g�(��E#
"���\3�e��/�T5�- �k�TH$�;- R���HYC�"e�
��5!S@��I���E�D�"8�HY�
"e�*��59R���H�9�蝂HS�
"�;��h�HC�NA��!R����"�,� �Є��HC�98��49�_��-�`Q�j�Թ�$z�\�i�� ��)�45Dj ��<�"M��m ��̧D��̡�s����$���D�"5�j��@��!R#�4ﴃHM�N;���۹j�)��4�X�5;��4������D	Dj�I��HM��I���i�4������TD�D�8�i�0@��a� ��f� R�i��_C�	"&�$��8[��͹<��1��|V�,Z������j�j�:T]�ڠj"վR�[����6��\���<>\���ӏ�]�j�',S͸�)R%�T�J6�F٤z�`S�P��U[��f�k�l��9�(!�f�WM�y��MF6�"��l�]u�`S�dk��lY���7������+ؔE��ț�hV�`S�d�-#o�"��U�s��h~͎9G�^�&Q��&��LĦ6��Ml2�
�d�1\�&���M&bS�L9l2Q�T�&���MYu�`SU�rM'M��M�{�\ӉFS�~�(�`S�tl�����MU4�U���f�
6U�LW���������`S����*z�6U�l*"69�TDlr�����`S�ɹ����&Q�k65U.���*�׆s:Uް��3m�W�4�өv��U;�t���s:�A�9�j���MI��t�өv:ؤک�`������$bS���MlJ"6u�)�����$bS���M�y�(^٤R�T��6�V�lR�$ؤZI�I��`�j%9�&�Jr�M��� �T+�	6��_'�$���W��������������������T>�³�M��7���~�kkT�&M���&�h��wM�t�»�^��DN���U�C_��Ý�pщY�/\���O�{�/���_;}�C�7u��E����&�t��E~�_xyC:|�M�4���7����D�ϬYQ"�M�{��h�ޓJl�"Jd�i��_x�"��ަ(3�/�MU��MS����)ʛ�o�j�^�&����6T�`�P=a�i��_x"6�ކ�M���!b|�m��_x"6U�!��J6��a��]t���wU._��N};|�.��t��]������j��p�`:|�.��t��]�[�������w�3���"L�/�U��������w�)���$b|��!�/�E΅_��<z�pW����3I��]������ȷ��w�K���"�F�/�E.�_��\�py�;|���%jT�&��%|�.��w��]�������-��wQ-R�\Ӊ�Թ��	�p�"u��]� �����wkd����N��puy�����d�/�E}/;|�.����wQ?�_��|k�����p�/�U�@��]�/���~��p������sw�/�8�jTч@�?L_��^�&Q_�_��N|�.ri�ļIu�`�ȥ1��4����ȹ0�w�sa��"�/�E�_����p����]�\����>�w��i���u�t"6�t"6��Z�_��\U���U����E����U3���f:�W�&�W�t��TY8���f:�We������/\���_�j�c�p�L�~᪙���E{k���E�����U+��6�We��.rU�� ����F�r�I�#���7���E���~�"7�`�p��s�_�j����E���~��Y�i�����E���~����~�:��~�"W�`�p�i|�Cu� _���}�N��p�!�����E�%}�^��pQߐA_��kԠ/\��a�.��:�u+�z���E]T|�C�[�y���.�;�u��:���Ec}��g��!�r���C_���ـ/|�|���pQר1�.�?|�C�F����w�>D��_�9y}�.�}�M�"�k:��wQ��>D��1�&��wQ�^}���i�rs���~r�}��ػ_��ߔ/����?���>;�������Qe͢�:!�|�|/��O��2|�Su����&|�St�>����y�����m; ����)��D�xн�=�1
���h>�)�4'|�S4_N���h1�󞢬z��=Ek�	��yx&|�S����yO�sh�$�S�>��]���]#�Dܽ��/sJ�|���>�/�����=E+������{�vj���}�����^����>�l�GwSq��RK�矻�t�� ���2���^}�g�-�vS1�Km�@���T����߮    "wSA�o�$�����v��M������
b?GE%c?�^*b�W��
b�%p7��KE�o� �����+c?��3��f�����vSA�o���T�[�^*��z/��ߞU��y?��W��e��Ę������K�{iP��*A�_nyU'|�]��_nW�����U;k��vщ�/��N�/�������eQEΣ/�|��1ܡ*�{��UE��W_A�cG�����5JPf׹F�zb\��)�,�>�)�?���NQ׎	�u(���NQ7����X�G;Eu�>�)�2��h��v�z��A6���A6�2�h���t�G;E��>�)�*���NQ�\�h-����Dt}��MN�!=��Q'-:?=����~t���o�p����~�%�L⷇�}��⟎�8�]Mj�j�2�ѳ-D�+M��VTx4i��NjE%@��ZQ����VS z���$u9�� /Ry�Dh�]U�H��aj�4X��&M��"6i��)�ISx�H�M�R�E
lҔv�Dí��¢za���'�u���Sx{c	�������7���Ͽ��e����w�8����Eْ��jQ�n/�c�r���(E\��iS���:y�o۟퓵-*84�~0s7�����c�Y�hƹ�q�O˛���w���}]F��;��'"�EF��~�Z֪�ou.��u�t�XT���6�tM�1dQ�隦;ʢ:�I-4�Ji��Xz-w;��������}q�yǢ����΢Z�*"z-wM��E���-��k�k��/��&i:</��g*��Z��o�.�`��kQ�O��E[P�o�.�؂2��k�Xe�Q����*��L5���3��k��I��^��
p�*ؤ�gޤz�ț4��U�M��qGޤ��#oRQ�����t�(O���tk�:���M���n��8U�I�a�Z�7٢
6i�Q���M{Ȣ
6i�Q���M۪�0U~?GĦ��&�:�t"6��r�8�U�I�\T�&��
��/�Xө�N6��0�t��^:�=�*=⪓xħ�T�q�	z-O�i=⚯�-�`��N����mG�0U�I�ΡG|�}"J��#~&��N�7=aZ�U�Z�5���*ؤ����MY�&Z�5u��*ؤ��^T�&M]Ң��:�{5Xŋh�n��o{����$Zq���&�U\��0Z�E�MF����h�7���&K�5]�7�!o�7���)�o2#�4��"G����&380E�380E�380U�������ػY䂴�5��Mt��\�Fw��it��\�Fw�*����0٤z���}������W���Ey���8���O?^��T]��
{l}���V��T�c����*!���A�UB�U{l}V	i�T���Y%��S��J���#T{l}���P	i�X���Y%�t5��5�����|o7����)C�K{�}������{l}�����̐�	��,k���b$�z�l}v1���|�ǻ^+� ��`���T���k>YV���(Je���&��/Ց��|���I}����[��n*�R�m|y�
�Wo=ʻ��{����
�Wo�i7|�j[#��
:�nW�{�\����%�չ|Q	ZB4.T��X�B%�5�
r����,*�{�RiP�z/*A�߰I�Ek��/oU�ؤ���آ�y?(�;c?h����/�,*p�j�;��"���vo�:9���^�����"���s9@��.r���]� 5v9@��.r���]������go�|yQ�DP����Z���]� �	6��go9@��.r���]� 58{��jp�v�WiU�M����Jr�&+�Ey�dޤy���.j��ش=�S���za�`�v�;L�k83��}{��ʼICĜx0��W~�PCČ&�}k�R5�I��e�D5����|�
6�>��xDl2�IԌ?�$��A6�I�>=�t�x�4��9�M�ϓ,�d�(��`��3�*���o�3Y�=k���#�#���+?E�َ�}���sdd_uX��	�W�&�!�6��:�sd��:[}�l��[�#[ �����Ȯ!e��8�sdI)�,(�m�'J����9���v;/N���]�ɢ�m7j�dA���t�,(�݂�����q����p%N���]��u��Ȯ!���q�kH�mm_�섬jB�紭ڌ�5�[����i[�'[ �����9m+��d��	șJ�F2)������-N�ڶ��E��{'�Tj��#N�TRQ
m�m۾%N�>��ڶ�y�dI)U��V�v[a��ȥ�}M�d��{]��3d;|*8��+K1�#JmO��dA���x�,(��&ϑ����q�����<G�z]_���"�z]5�sdI)�,�㯬�x�,(u[����m����nk鲇,(u[ǃ=dA�ۺ,���*�Ǜ%�;����?<�f���>�U Z�5B�
0��W����3,�Ee����^�g�9� ��jS�#�m�5�d�mmJ�,��-ĉ��^���Ȃ`��8Y k[O'�-,�d�m+�dKb�%�%�R����~����dA���=y�,(�����ȂR����,(�����ȂR���YP�u��#J��_�3daCe���rKE)c.%�[��n
��i�>6Nǁ*�O�=�L?n��2��ѓ��S�GO*�O�!=�L?���2�Xғ�@]2(�2P�ԓʈY�RO�eu�K=���.��ZV�ԓjY]�RO�eu�K=���.��ZV�ԓlY]�K�(�zR��ԧ�y&�"�a,���\�ꀪf����T���zR9~
�I��)p�'�����T��RI(�"��*h)��'��-�*�i�E]�	�B���ưС��1,t��j��B���ưС��1,t��
Z
�Ie�,t�wٻ�bO�)t���7�u�����nv޼Z���j�jYP�foͫeA���&N�ꪉ�1��=dRJ5�ѡ�2a8�SWQ
��U��C=u��PO]E)8��PP��Rp���s�dA���k�d��m�����e�q7H�,K�%ɪ��$3����d&ԓ���z��x`PO2�`*���`AO2<�If�\���**�>��:O���yR��Γ�ư�u�T5���1,p�'U�a�\�(5I)Qv^�:O�"�
�yR�V�γ�������S]3*o���:T5�v+�yۤ(L�c4i�cW���EQ�ꄪ�lQ�6Ϣs�
�yޮ/�T�&�j��j�+*��y۹-Ll��&
S�����Ta��v&
S��`kS
SEU�֥�
�yٚ��T��x��ܶ'Ma�`ӶO\�*�$���l}��]�E�0�g��*��Y�!�
kyޞ�G��Y�EO�0����{�*�&Q'�Z�7��p!�DsL�ek�S����0U�i{��
6m���T����{�*<�y{���5��Mp���{�*�$��*��Dl��<�2S�ɋ�h�rM'""���?Wxɋ�S�V�"��w����>a^a$/�ϵW�ȋ���6�-ySE�$��x���l�T��m�c�*�$�dc����>�^a /��U�ǋ�#{��"��`�{��>�Xa/�EVxǋ裘�1o�	��<S�DN��{�"�νp�{�k�ؙJ�
6m��T��m�c�*ش�qS��%�a�`Ӷ�1L�lR�a�I4�t"n���
6m���T��m+�0U�i�I-Ll�6RS�N�&�ď��4�\Ӊ�a��˶�Z�*�m�y�*<�Yu��x�Z��T�!P�oؖ\征?<��7��g����r���U�xó�}Æ�"ײ'�I��F�"��.Z5;|�Y�jv��E�f�/\�jv��E�f�/\�jv��E�f�/\�jv��Eٚ�.:u� ���p�o�p�o���tM�����}����9�p�o�p�o�p�o<3o�a��E�#N_�hG��7���3�$��s��MT���������7Q�g��Dl�/�DU|^�&Q>\��$b|�&rA:}�V�_x�`��p����`��p����`��p����`��p�����:}ᢆ�N_�����gч��,�����]�&�³��_x�6�	S�\�&���    ��N�*ش����>N�}��64cx�6B�Y�Id5rg��(I�1<��7cx�o��,��8��Yd�qó�~�0��,��`�"����E�o\ԩ"l�x�N�&ó���aϢ2>�1<�����,*�só���aϢ2>�\ԉ�ԙ7���N�J�y�Juͦ�J�a���0cxU�o`�*���U���a���Fcx5prë���0�WՖ��UT>�0�W�5��ڄ�1��6�`���5ëj#���4�1��6�a���pëʦ1�&�:��*2�5ëȐ�`�"�Q�1������Ud!k0�W�]��^E��cx� ��Ud�l�lR��M7ë����~,�ר�M��g��*ڗh0�WQk�f\өF�$*�j0�WQ)j�1��NB��M�{�1��N��U���`��S�cx��5ë�t�e�It�`��S�cx��[&�D�+��i�?eIip�W��`+������i�0q'8ë���^E����*�Emp�WQ-j�3������*��J6����*�h78ëȏ���"�}�3�����UTS������gx��48ë�.�U�I�p�W����^EV�gxa��Ud�ip�W����^Ef�cx���Ud�k0�W�!�97�D���&њ��E���U�W0�O�j��h�>UG�0�WQu~k4�r	ë�Wac�pQ��Ǝ�'̎�*�B��@�7�c���f�1��l��bS'�T���p�hBW^ٽ"oui4����4�Ea��~���Eݪ;����6�]���c�콒M�{eޤz�d�h��U2�U���EE�I6��0�᢯7Ëȶ�`/��+��Ee��1\�3��^D�m��"*��0�Q�W�1�����"*��0��z"�T�`���'�4�!��"*��0�Q�W�1��ʽ��M�Us�1\�E�cx�Tt�N�
6���1���cx��;��ET>ҍy�h4��D3��/�t�E_��4���8zfޤ�W�I�^�7���:���~6���O��yVo�yQ���N��F��Tm"U[��G�@5�^�H�@u�T+�p�:�u�T��D��ZD�d�*r�&�k%�D﵂M.�lrќS�&���M.�p��j��t��@lrѬ^�&e0�y�h���*�W_����j��h�q��D���&ս:��j4�MS��;TE����(1A	����&�����!MySEN+�W�[���Ml�xmX�Q�6�M]��5�M]E	�M]D��5]e���M"6u�MCu�̛T�ț�j4aM�U�
6e�h��h��`S�tlʢ�n�MY4��)�f����D�:�&�L7���z�`���u�M&��6�*^�&S�+�d��4�����nbM���`SQb�MIu�`��T���R�\9`SU�+�TUcl��Y}$�MUæ��7UM>�T5��H`S���#�MU3���5�&rF���M#qM�a�H`SQ=a����d`S����"b��ME�&���M�5��MƼI��ƼI�ʼI��s:��t�lmd��T�ZƚN��e셫���s:U��qN���2��T�Z��@E��*G�d�([�/�T�/�T�|����7U�_���5��M���n�l�pSek����a�n"O�(̛D�
_��<���K%�@�{��
_xھ��G*��#�aI|������p���/~x����;|�ܫ �D5,>qհ��EUB>qUD��MTs6�7Q}ݠO\t�0��&��E�;>qU	��MTu0����\�􉋪I}�:�A����n�'.�u􉋜�>q�t��U�}�"oנO\�;����Jh�'n"o׀O�Dޮ����]>qy�|�&�v��U���l������:��$b|�Dl�Oܒ�M��[�	>qK"6�'nI�&�ē(rkEl�Oܦ�M����:�7QmҀO�D�3c��Nu�`��rf�'n�ʙA���rf�'.����u""�'n��1�."��N�
6�jD��N�^��.b|�&�3�7Q׷	�����M����+":A������NvW��t��hw�
�\���M��MT�?�3/���	�y�O�̋�Ԅϼ���L�̋�Ʉϼ���L�̋h�j�g^D�Ȅϼ���	�yuɘF6�T�&Qg�	�y�VL�̋�b�g^D�>�":����i��`�h�l�g^D�>�":����ińϼ�N�'|�E��g^D�	�yy�&|�E�����o�g^D�	�yyK&|�E�����z�M��Z�&Q��g.:I��Q�	�yu���Q��	_y�n��Q��	_y����Q��Y�&Q.��o�	��*� L���vGO�s�yڞ6ʮ�y�(��;O��Gٽ7\ŝ��KO��I�U\���*&����*�cO��L�U0o�2�l�;�;���pθ]�ˮ�ܮ�eWVnW��� +�� �� +���� +������>mwdWa��|�� ;����*�έ+Fv`�Lv`綛��*x� Z3w�5�2�N6�iU�;�����mu��*��m'�U��~��u i[,�
�Ԝǵc�����JY~"�|˴��Qu�ď�}h)}�(;ޤr�]f��>���Ï�����W���:����=�=c���e��@����%�
0y�GAv`�s��*Pϐ��eW&o;5ʮL�vn�]��wb2�!Ҷ���*��$�>"m{T����V�ɮ��U^T���xQ)�pۧP�ďҸ����E��w�Zi�W�%kY�Y_q��e�F��b �
���#X�kj�)�Pr�H!O�Vת�8�/Ҷ�Vv`��Vv`�Wv��hz�.�8��h^T�j��/�d��ٹ��m�͋*��ێ߲1��O��y�}��5�������V���-8ɪ�S�>�(k�\Ê8�z���+���&G�'�sdM����5�(rPϑ5�^O��Ț�[O���G�'�sd����9����	�Y����z��q�zB=G�8z=�El*d�(��\#�io �YSi�i��Yߡ������Xߡ���'�wh�!���o�yb}��b�Xߡ���'�wh�!�	��^{���(�/^yb}Ƕ/����.Qv������GW�JU�Iϓso^�i�kM&O�^H"N��h:�zb�Ŷ%L��t��z���穑M".�����L�q��^W���;�젞�l�p'�
��^�ͨ�(�:�@=E�W�z�rG�'�S�{��;���)�F=E�|���'�u�z�{��w�Ke֨�(�z�(U�O���U�O���E�kTQf=��&ʬQ�P4�D[T�.Qf=��݉]�uˍ���	~�U��Z^]E{�df�O�X��������o~����O���o�\������_.�f}8^�\֖g�j��5���C�|c���^����_��]��Q�)���n�6�_���*���JR1�� ��[��KT�Z�]sԝU*Tz���/#D��������z��_ns���Xk�넼���n��ޏҮ&��,�6-�����Ǘ]-�;��HϿ��[��|�
�[f��k84�&�����������O����^<M���Zz<���p�ʻ�Z�/��wmHZrR�槙c�ؔ������u�����คv���dC��K ֺ4��������9Զ?����K�aS|�K0\�;��_B�%ܰ��%���@R�*/Ŭ%-|�2͍6��-�ٗ�(v��5�]1��- ������� �`W�b���`�h1{WV��Y�ޕ�*��]Y��-��KT��t�f�KT��[�u^����{�SiӶ�Ls	W��#Rni���%<��O�����\���1���K�G��h[?_�=��G����?ڏ�ж���Kh�pK���/�����t��@:�#"t��/����E��c��K��r��.�%���4���@�[���%8��=��s��t�_�xKo��/t��I���H�{�������_r�[���	�U���ҧuXy8��j��q=�iۺ�T�ܲ�^~�`i��a������Ï�[���?,��WO�W�^n�}���׾^oYa�s �-�p�B ڶ�_s	$�=R����e��/���{��D�    ���_�[>��% ߻�k&�_�[>��%p5|4u��O��	��-���@�[>ٱ�%��ca���|n�K �5��K o�������= =H�{�t�v?�\s�{�q0w�G�4@�m�&�%L�q��Is	�㶝���;ރ�t�6z�\OR�1SN�q۞Ns	��]��mկ��q۷_s	��-���rb�x:�D:�aA��x�`N��m�Uk.��m�n�%������:��=��xcN��=\89�����g�a�͆s�m�u�%��wH_�!w���=r�{������(�:��m��/t�Gah6�3��)�����g�v��ui�K �hbi���) w���������>?�_�>ni���%���.A	�-����8��_��\
�niŶ�%�q�E�%0w�G�R@�[��	\Y�c�.��-������v��_�x������wy
��-����w�o��4�N�x����rǀ��/����{�Te���e:d�=zd���e:D��e:d�]rT���e:d�](�:��L�����梃�wI�t��z�u4w9�a�]N6u4��#�h�X`�]vsXGs�ʲ�:���챎�.�����G�af�=ZZ�:�es���w�\l<���p<��ϭ,뢔��~���.}���}���Q��TO���I�t޷��Y�/����{���?�FM��{�ϵ���[)��y�jy[˟| R����/�/j�
���wȻZ�A���;�Z�ԓc�Kj��;�35v�gj�P�������3@=Scg�z��� �L�nP/�s�A�iﾝ�V�� �Tr2A׬��]]=�'���cl��Y~���|z�ry�5���	�fu^1A�*�]�<�A�*~�%�zU�֔�UqZS�����;%!��⴦$P��WS%�z.��J�\L��@=S�$���g�?/g��zY�#���5RO���=�ת_�P/�_lQ}�5��.���O�e5T��䀹P����}��5C�&�+���
}�٠�C�Nt��u�"�Kx��YDx��M�Z�B������o�j�����7���|˟+J�Z����q�<�g��:��gj�P���)�^�������˃z����g�	��/�2�t:QjZ���jk���{%]��_=��
y��R�ꔶ6ȫ�
�65�ꀼzj����sP���I=�z�3��q�^WO9�u5v��j�8���I��z]�'���u5���.��Z��ֵ����-�C��Y����*��Z ��jK�V�!Z`л�]���c��.�lI/��d���=����'�nyМ
�S��;�!�4hv�f^k��3�5�I4+45��Ь��,���LMp�j4�!�hr�H4��*a� ��d�p�j�-8T%L�P��o�CU��U��9��,�M8T%�2I>4�!�ph2�ph�C.���\¡Ii�8d�gu	�&8�4�%E��%���	J�X�	J�9�&p()������������PM�PR��5�C�X���|H�	��Ce�2p�$2p�$2p�$2p�$2p�$L0p(+�j�P��'9$�ʒ���$>38�%���,��LIb%_9TuyB���&Vr[kN͸��Ԍ�M͸�Д�&%AS2n��4-Ir͒���$L(�����CM5��Y��&�P���C�ҼOpH�v��|Ȇ$V�a��0��C�uv�4�
I�j%�$sv�4k�Ji�-8��è䐄}�|H�'���f����f�����y�䐄	��2M��&V:4%L�MIn���7�C�q���q�24%�I+�O	�Z������C��J���C�S�f�qHr�������&V:�!:�!�:�!�;�e����C�9�c]��M:9�y���&��d.�Аp~��̇$����u�C&�I��u�C�s���!I]G���ޡNpHR�P'8$�w����ޡN�C�z�:�!I�C����ޡNpH����;�	Ij���$���!I��'p�)���O��t����C��.�<[p�+��8�5���y��fܒC�<�r�2p�%cȐ�b�vC>�a��C��n����9���$�Hn�PּOpH�3�I|ƞ�����O��j_�3}�����$�̇$y<��]���O�%y��]�>��5y<��I2����Y�Bi4�!I�!��Z��駖�r��%�j�~jI�#��ZR��~�S�H�?��C����>3A��u��&�駖Ծ;�Ԓ��Z���駖�g;�Ԓވ^qn/z��1J� �Q�*���U�{s�>��}�}j����ߛ�O���t��5��?�������:�����O�Y��O��5�����~jI���O-�/s��%�$N?����駖�:�Ԓ�2o�d�Fj�ԗy'�$���MR_��Om���!����M����Z��dj�_�駖Ԝ:�Sk�:؟Zs���Ԛ3��!I�s��Z�w����0؟Z�cjIgjIgjIgjIgjIg�&�W؟Zқ�ٟZR���O����?����ٟZR��O-��r����]9�SK����Ԓ�*-�C�m��Z��i?������%~����_Mcj���?��'�؟ZR+�؟Z��o��!���?�Ijf�aH��5��6I~�П�$k����&Y�5��6I~�П�${��M�'�?�I� Z&�$��!I|�?�Ijf�S���epHR��28$ٓj�x~[f4	o38�Y;dpH��o��鴂u�į�
�!	�8�Y��CpH�,�d^)��f-X�!��$�$�ej;IE>$��*8$�߶
I�:Z�$u��C���V�!I]G��P�<[pH��n�SK���&�9m�S��N�99�y����n�9�!I|�?���Z���$�*j�O-��؟Z�M�F?��WW��Z�O��O-��4����$k�SK��5��%=��Ԓ^z�~jI��F?��7b��Z�{��O-�Co�SK��5��%=��O=ҟ�kk��j���m�\�Q�-�O��-+�r�TKd+d�J�!�U�m-{��Kd;dde#yB��d�>�lQ�d�J6CV5�GU��*8��*nG��
���2�,(e�!��T����	���<A����d.��
f�C��V��2r)S�q6ܭ*�������R1y"�2��r)�۞@)�mOȥL�=a�g��'���(s�	�R1�'��T��	�rٻ�\Ǟ@)W)��h���\J��7��Y5(Ue������n��*n��Rŭu�p�w{�TIׯH~��x�̕G�f_)|���}���g�_>_���,U�2�TTX�Ē*b2�xC5�gnD�5s#J��Q�����!���	6���ɓ*�J�ݪ�bɪ�V!�d���PQ��RCE��䩩(U�<��R�K<�
)����\�l�i\�0g�	����R[���/���y:_�S��t�T�b<l/�q�<]/�ixnak��q?O��Ku���aZ�y��<�OO�/�z<�a<pd��tG�:C�NZ<������7d�/�an�JW��E����%�/��jcn6w5����Ku��|"/�an6�r���/�Y�S���>üa�oH5n�,z�S��pB�q�v�u:�p���Ku��K;����l���T{+p.���p�\n��8��lo��&�[�s���\�Y5��\n���s�5�,)�J��\n2#��Mf�s�Ɍ ���*J���dF:�eF:�o�!�I��kù�n���I��a�s'YP����dA�6Ew��n8��I�j���v��N��T�
F"�D߀s�X*+�e.%�Ԁs�5�F�OD����Qj���U6��r��`g'�5�\��p.��j4�\vY�¹첸�s�eq����eW�o��.���\vUR3�\v�bd(���02��Dv��쪚�#��j��̮�y02��~dRJ&KJ�&>�]e�02�ʫ7`dv��wd�R�!#����FfWY{��.[h���#�#����G!�T�-�̮څ����R02�jnPJ�����jnTRJ@�R�buM��j�6j��*��CV��� ��c�Ue��R���+>U 9(� �  jf6��ne���j*�5�Um��ٮjB8�����p�R����mWu�NJ��y_S�����窻mܗRM�}?d}?�*nr)Y�
Kx���s)�ԐK�vj��ݪ��FJ�&�� �
��\Jv����U�*bt��TL�\�(﹫:�xϫl��]���nQ�ew�6 Y�dv�Ϊ�]����욝UL���ˎ�=�]8x�KQ���.[߲kv�=d���pJ�H�l��z��w�N��]�/�yɪ��.s��{�e�xϻlc��.��=��[xϻj�f�{�U�31���	�yWٴ&�f��%g�A�nI)�j~&��dwKJ�dA)�ń���̤ӘK�d�K�F2��M��<�=o�}�	�y�ŭ����݂R*�d�l�~����6�'��M��9�=o��	�ySm�Oxϛ�e2�=Wyj&��*��ȥT�I��6�=/Y��I)��v�{.�oW|*8RJ�/5�=o2\�R����\6��{��[�D�1��&K��=o2&�{��{Lxϛ�=�=�ɒR��LJ�&�JJ�d�K��[t�N�3����g���9|��>��W�Q��Cz���?Yf�ç�_,��}���7?[��秿���7�_.������������yI��<W�?:^y{��_n�?,x{'~j�x���/~x��r[�;|���'�������-*]t�NE�>��;]��떜)�����˲���5��C��t���G������O�����x]tO�#q�.�tݣ�OE��0��,��q<ټ���,��F^�ⷑW����.~��*�ߎ�U�~;Z���N^��^��~�_��s�L7��+��G�2ݸ�L6u��d��`~%[��W����l�N�2��+�x�e��U��jp=(�� �d녙����m�Q������e����y������o�������DNuC���M|&��/��W�nh>�R|E�ު/��7�>�4'>u�m�:�l��B/��g�n�nx�>uC�ƋtZJXs�Pw�R����Ku���������/թgfO�K&��rt����^�����Y������?������Q���D���'�����ҷ�|���7�xoU;�a����'��B��vo�V�x�I��Z�ZЍM�X��!ih����,��R��ӒG��f�����s��k��w5r���5J�8!���'����1��,[���������Xr�Z��E�����3?�(�.��r��r����P'!3����������K�26>����R�FG�7J[��؈��jKQߐm)c�"�s�-elT��|�6&�>��R���&���a�`c4�[�-� ��-� ��-� ��-� ,�,؄���Ku� ��0A�N�&�-_�Ãް�Vi��{noa|�oa����nh/�B�W�x�Q��ݗ� �����:�*�J��PHbk��Z�>�eV��eT؇�t������rW��,��k��Z���� ���;�xt#L�h�\	�8!�P���8���Qw�A��r��cx
�%Nd��� 2��8F\u�a�=�2����A���͂�@|G �>:�����A��=��=��q9� �E�$�.c}���ϸ���v�{������s���2�8$�sg������s�QpE�I��o�q���߶���
�w���r_�Ӱܿ�r�}�C�$�tD<����
M���
Mf%�	��;0�i��u��*HI�Y�*�M���<����}��I��� �O�W����w���:�	�ˮK�(��k�[:�/�����lV�N<䩑�����n�J� k*ټ~�C4���H�Ι�m���K�Z�Ho��νd�����,��e��YY���l�E�Kv���BX::X k	��!eYՐ2bI5��@Va���T#�w+J'̘<�Fr�ݺJ��wJ�2(5T�6�RCE�JM�2(5U�ʤ�h`��*JeRJ��JMYܒR�w;Wˀ|CܾpP�Z�)�:�e��@x�N��<=J^��eZ�N���˴��8�[�8h����	�R����e`�=M����\�^U��&������۫�E�(�:a���0�W���hQA�2���)�u�<�y���UK�:!���s�X��q���<�^�dS-y�H� �r�T^�xQa~_��԰@�1�Z�x7��5�����"L�q��zh�;,,h�;n`�Ku�wܰ��Rࡄ����h�J{[[���kU���V&;!�BrO�U��v��j$�Y�nV/�U���
YUJ�I)U�A)W�۽CV�J��R}M�$;��TU=�Ju.(UU��T��-(%���TUM|��RM���aa��,)%{�ȥ�j*���j⛠���<A)WQj�R���d.%{���
sM���X���vM�,c��1�Y�|��AV�9eȊ2ǜ
dELΩBV4�����L�����YQ.�r�.�TNȥ��R�\��(e��(��J�6���)�t���, r�.{���*s�J�*M�1�R�ѐK�6�s���!gPJ�i�3)��EF.�ڴ���j�>g�R�M��A)զ}Τ�*����/M�C�T�Z�jr�ܭL� �z�W�EV5\�Y��鳬l�YPǪ:��u����nꢂc�n���$suQ�m��*n+r)UAi��\*�
�r%�T�T%�T#���^�����WM�~)Uz^A)Yz^A)Yz�̥Tq�ȥd�cŧji���m�;)����R?eg.����R��'�d�ONJ����ޗJ��f3Ȫ�!�R�F��sU'��*��R�'U��yV��ɭ�neq�3>UC��yR�s'�TC��R����$;H��\�0wPJ�T'�{�T�s'�T���<˦xϳ.��{�
 xϳ���,c�`.�z��g�T �yRu���'��60Y�z�U}S�X?6�:i~EYx;*XF���~���O?8������l�۟������~���G�x8�u�SAv����^���'ʀ���x�/��G���2=e�}�/��7��4�弹���8�%��e�
��KƏ���!�e�(��O����Ʀ��a%ց��)1��JB�?ս����=�jK���)�_��~�;���U�����Q�*(�@��V:�	)�Z�]��'��J_�r�P_�j�M��������X��E>�	���З�Ζ�G���~o��J���@%p�L� %p��%%H	8wR<R	T8ۡ�����`D��F����`DK�J`DdD#�~J��Z 2��@�df�����w��F��ȱ��/�o� �=�D�G�"�#� �=�������5p�p���T(�y}#J`vPȈ�Q������A��T(����Bฮ�B�o\(��{r q*8`�o�@�Tp������v�ǀ3;䦃u�1p�mD~	����~1s���g-��|���]�ˎ��v��d�x[˞?���k��΁Bv@v�d'd�H�%�6��AV5�[�lU�Ȫ�U�f�,(u�����*n(5dqJY܂RYu�����WJ�)#QP���
YP����JuU�vP��F2(�Uq�A���o;(�eqJu�|;@����@.�U�� �dwJ�݂RC@�B)�Ҹ̥TS� ��j��T��-s)��7A����&(�US���j*��TV�q�RY�	J��� GU��YY�2��=䉻ᢦ���h$�d�[�jʐQ��Y�j����[_)PM#YD��:dE��i@V���iBVE)#�D�y5�K�(e�*Jr���[#�T#ٮ�T9���!ӾRuU�5� �3�j�ѡ�B44<Dc!KO�o��K�����1�.������[�w�^u6=;���S[W�|����+�����7�,Z�{�}I���m:̓5B�@�EHԣ�\��q]TO�Q⻯����.N��K4H��	��x�(��k�p�����������x+����o���o���o�Ʋ�7�����<��{�?�,���2y=�\~8������e�n�������~��~��}�      �   �  x��V�n�F][_1���&)ڟ���E�(��h�Ra!��.� i��JɢD�"�3��/�9�^Rr��>6`����8��{���G,�&�u,�4���o�/˔��!\���4�^�7i��8b�oS|�y���1��t��i��i���.R���G�X�C�ƴ���i���[v8��.���yָ瞆�z��*�Ni��Nӝa��,�탏������l��wϵA�w�P8�"F���-��=W���M�A.����V��v���:�L3|bh?*���yXn���{�����e���`��x�G�D/�0#��-������9�	+٨ux�dn	A ��" H2G8n�a��ų�/F�/�;SN���L��Ϗ�ߏ^|��gm�om]��׏L6݁ǩ�̬ɫqH�I+�a�x8�Ţ�T�dx4?I�Q�u�l)�k���Vㄆ��ޝs��@޵Yod���G� Ǵ�l��Lz�����taV��^`v%��F	�
u4	>�_��3S��'x��#�sf����ʇkȢc^⺓�&�]�@K���R1&ѷ����!���3�$=���]@��)�$�A�۠%���t���gdb��aQ�T{i�(I�UE��MP����T��`Ց) pQ���1����2%��>A(I�rGH�a��+�]P�5ɩu�1���YH�p�ei�_:d��es�.X��NP�$��R�����d}Ѯ$=n���"×�ՉlHP�Z��bћͭ|!�j�$o�iw��Ø
���r�e�,�Fl���U/�2��F)������F�{I
/lO־YR��,vv �D+4`%�s����Y~)�5xrk�ӡ�����৛'�3��?�Ԡ���~c���(�ǵjg���ǁz�HX�LvЗ�ӊ7&9"	�����J�oP�(sk�h�a���sT'i�)2rر�����N�����ygchP���>�S����k�J����c����6�3�#�i}-��[��/
`�)]�T9o��Ag,S<L%,��k������O�˷C��_}F!8�ʵ�Q�e�T��喳��#��i�������r��*�7T�[U��yG�^����D��Μuvc�u9xi��|[��R��#�RPP3�g{8e��~c-͵����r�*R�.#�����Fa�g�m�>	���.6[N[PC��-�5��2e��e��>e|���_��𧻓�ox�����W�?\��ƣ���,�~      �     x�m�K�$G�����TH�W.�����7��0s��4M��լ�1��+��Ȓ""K�)�E��#����G���q�c}� ��/����}�/�tY_B|����C�&������P<z}����
܎����EY<E��xr� ��z��/���~�{���8�Xν�V���p�EW��� �~\z�`׎�F�1zX�Ap%��xRH��ú!�n8f������Ѯ�Ƴ�E4�v����PW8�Jx��@t��%9���r�HI��/����hRCs�nY�$����eg��%t�@���r{rv1�*G��FL[���0I�R�צ�sHˎ?��������G���L�;Y�((�#WZ,S�U�q����q~fF����S��P����(���_�I.����d_�a/œ���ruk�$n�'�C�.�
��n��Ҭ����-���eO�܊�խ���i>�_��.;�}�Z�tl�3�����l��}����g����Y`��P]^7��=_Խ9T�/g���P}�s����K�a�Th���V�/��ʷ_X���<s�h�KX�	��R'䭘xk3���y����x��a�y��,B�!h		!!�&��q����\��ٲ�Ί��*gk�R�&a�G$Ml�D�hH�� ,�� -�B�q�d�:gC�:k�	�"5B�Q��ZM��X"��\,�\-�\�,gL��s6Ds��	���V�ٳ�<��<y��|N�`��C�������{��RQl�KA��<8L�!r�۠�YR�%����)/$3y���K0�(�$h�FNDc��\ֿ�Ђ��
���ǖzT料3A�b���K�G%M�� <����fԜ�iy�����q�q�\gL=�$���%θ�/0�>�g�{L3.2Q�;%��VYɎ8�+�$
�g��k�������Qŭ�:�L�ǵ�]x�*Y(C\�%r�Լ'��LF�]M�7�I�.��w�'f����o�����&�}ot�܂�6H�1�p�X�P6�f�ض��T��'�W���~B�a@�      �   ?  x��R�r�@]ÿ�B�wAФ-i�"5US�D�i�
��d3���Od1�Լ��h�3�,����}��sEf�z�:AQ�cZB���^���Icn��Ĭ���D�F!J^�޺�3]�d�����>8�u�+g��
A1B��/�]gi���4f��s��~>|���O�G�w�#���-�@�IǗ�%���)�z��VB�1hC��Pѷ��	�\ �� �%�Q	+���Ώ�_��ԁx�bf}T�X㦗��HI�#ӈ�gJ	�h�m���[Ž�u��>.�,�q�-�B�vW�eҿZ�|�]�^1���Ķ�̍�4{��Ԝ[��.傦�b�D���}f���9���sӵ��D��;G [���.�9넞5;�зH�=u��J{�J7P�lF],~J�Mo5��(@�������b�E���ʭ��u�"r��K���I3�E3�tx<<�O�������ဲl��/����	���p��jآ���.@�"�W��7waZ$j��
UOXdz͙��m���ؙ݂������Mv9$�M|另�dW��?НR�M���E�^�k����,��@     