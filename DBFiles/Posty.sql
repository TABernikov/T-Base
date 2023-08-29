PGDMP         &                {            t-base    15.3    15.3 ]    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public          postgres    false    220   }       �          0    16568 	   deviceLog 
   TABLE DATA           i   COPY public."deviceLog" ("logId", "deviceId", "eventType", "eventText", "eventTime", "user") FROM stdin;
    public          postgres    false    231   @�       �          0    16583    eventTypesNames 
   TABLE DATA           C   COPY public."eventTypesNames" ("NamesId", "eventName") FROM stdin;
    public          postgres    false    233   �=      �          0    16535 	   orderList 
   TABLE DATA           s   COPY public."orderList" ("orderListId", "orderId", model, amout, "servType", "srevActDate", "lastRed") FROM stdin;
    public          postgres    false    227   N>      �          0    16514    orders 
   TABLE DATA           �   COPY public.orders ("orderId", meneger, "orderDate", "reqDate", "promDate", "shDate", "isAct", coment, customer, partner, disributor, name, "1СName") FROM stdin;
    public          postgres    false    225   �B      �          0    16419    sns 
   TABLE DATA           �   COPY public.sns ("snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder") FROM stdin;
    public          postgres    false    219   H      �          0    16860 
   snscomment 
   TABLE DATA           6   COPY public.snscomment ("snsId", comment) FROM stdin;
    public          postgres    false    240   .      �          0    16410    tModels 
   TABLE DATA           ?   COPY public."tModels" ("tModelsId", "tModelsName") FROM stdin;
    public          postgres    false    217   S      �          0    16401    users 
   TABLE DATA           P   COPY public.users (userid, login, pass, email, name, access, token) FROM stdin;
    public          postgres    false    215   p"      �           0    0    accesNames_accessId_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."accesNames_accessId_seq"', 1, false);
          public          postgres    false    228            �           0    0    deviceLog_logId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."deviceLog_logId_seq"', 9, true);
          public          postgres    false    230            �           0    0    eventTypesNames_NamesId_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."eventTypesNames_NamesId_seq"', 1, false);
          public          postgres    false    232            �           0    0    orderList_orderListId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."orderList_orderListId_seq"', 5, true);
          public          postgres    false    226            �           0    0    orders_orderId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."orders_orderId_seq"', 50, true);
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
       public          postgres    false    229    3317    215            �   O   x�3�tL����2�0�bÅ}v\�~a��r��b��e�ya�]v_�pa�1�9�^��[.l���bW� �*(�      �   ;   x�3�0I�bÅ6^�w���V.C�/컰,���>.#�s/lU�؈"���� ��#}      �     x�e�]r�6��/��QM������f��8��T��⺤.� HY ���:�Dс/o�~���ꛋ|ܩ$���F\S&psՒ�W�fr�8���/;���^�o�t���pp�y �V�3���X(B5��������.�C�DM�b���a�]u�*�<�X&FͪE���1
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
�-l�!٭�{��a���f���6��zՎ��-/�9n��r��v�K����,�~W��K͖F�h�Sޞ6�� {��Om�7f!ȹ��R�      �   �  x���[�� E�a���Bⵖ��l�ӝL۷�]��#8BOILIk��J�R�W!{�'�Wi��Au	-�ܜ3�=��T%�=:��&����J�Ϝ�F����钾�ؖX�8�Hy{o[��l�2����+�g�c�TGC�d��$��/��j�n4����X�ظ����$y�����o�%�t�7�3�t����h����:(����K{6П~�ޓmj��`�lwVzj ;�=�R�����t��� ���4��B�r�,�Z��C�������l�ܲ��`��Y��ۜ�N�X��{zaX:� �W%��v���(ܳK�h����?ܗ�l�{��|����`9���7�xO���U#��������/!�vgmQ:���3w�E�Vd�u�l��(X]U�����{z}o�2d%/�>�K�ۢ���ja�,����Vˢ�U����{��	��1���pe��V��Kѯ���� Y\V�u��L]�QԷh�|��h��'�trI�I[6+@sд��%-AW(�t�S�=��w��-�ރ�i�8i/�E >t�gQ��{���{<|�v�n�:;K�䇦{<�Σ���at
��R*g+��C*y�F����U ~n��׷�(�o����<���P�͕ { AՍ3��n�B�<�^�r��zGt��W1�c뵖Ѐx��k�~
2`V� 2`n�s�mPݙ[�Z��~TJ�����^�\v�����
(+��s���@e�p*�(�l���ns=`+�bԠ[2֡�l˶�!~[F2�+�Ac;�J8$���`�� x�U�Cn4O
��� �OQX�v�uI3�R[wz�f��{�_�~��5^�0��?�2��n�[�!����aw_�n���h����� ��a׿�@�ݛv@ېC�����]!�Jv��lt	��9?��B�#aW�<r�"r+��I�m%��G͓glm­���]���jkG�Y~�=K��ƥ��X�x�U���P��Ej���q���u�j�U�4���p�`�!׎��'��9�!-��\�)BmEw�(�5�6� ��ׂ���۰#��];�Bs�~�@�j���ju��ێuD�;y=�GU_�{��EJ���')�������E?�*S�1G)�x���_EB�H      �   #  x��W�n�F}�~��O�]rI�T�������)�p�l�8m�ȁ_t���(Q������Q�e��͕k���;{v.gƉc�y��E��D�	�O��%�x��E凲�׬�^<^Ie�i���F��)R٥*��S�:���|�)�Q�N(�x��A�N�3�kj�vf�/)����q�P��?H�5��I��Wj�r�Y1Rg��5l{�����On�	���=5hϥ=��:8Sj_�t]�T����]�{����=���%�v���~@ڧ���@����;U�iс�mw����k���h�F�z'�-�t�}bK�c|e�>��I_�(�t���G�z�y|y^�.����|���G_k��WS����0,L�p���-�`G��m_:8!N��!��>�k�S[��lr��~{��d�+c��b�=����Y1kz�`Ѿ��'j;�x	�T��4�N*�C a3�_q'"��Ӕ8#��B~��96{�y����7�ɁuO6�Ɛ]��L�5f��ל�eLs����(�H��,h{��C{��/;X��/ s;���-/�ik�#;��`�b�v�9
��L<�N1�>�Y�Jl�;٧��^Lk�:���� u�s9�q��7a�=�
�+�� �� �>ذɜ�) ���3��YR�n�	Q¸)	�(ǩu��h����-kr�̍��ǡ�'����Pa6�
Ug�,:K2ݥ�zlΞ튫m)>�ꉋ�����-*�� Gf/y�)��a��>�"y���xC<���S1I�YXX`�73�s�k��ϯ�)�T����Ł8d�|�s;lq5|���朔e$�_,�j�
�	���j@y��9B�~g��*��w�������e=6�P�x��4Ro#�Q��

<�L5-�qC»�!4����<]���.���o}��	V��c�Ka�E�Yt�'���b�p���iǻ�桦�0�sa�",��cS���rC�&��>y�veL�1A_��~;�km3U֙1%l7��oJ�AÁUc��qU�������(�WjR��ӛ�HW%�e�1ʟ�GF?�1W��#��C��+i�8���I�Mx)]D��6��pvE[pC]�dR��ٕ42\�DU~���
3V�6�#�����pg�qV���ˏ��7��&�O��:��E��'>�=Nj?����u�����!p���&9UR�L�ʞ� 냡�:΃_��������t��h�y��mdX��N�EטR��y�������ʏ?/�ܢ�iNo;>���R�_��1�      �      x�̽ݮ-�q�w���"aow~\���Ѧ���0`��li�=�X	��f�3�� ���&���~#gV�U��w���'jm����眮_Ff�?#3�����Vgc�R*��;��^�S�j��ngv�ߏ����m�����;�3����.?hmv�S�%��/)���#� �$y9�H �h9�H$�,����U)f�ܰ?{��%��v�B�+3~���H�]��j��-�b�S��宜0$���r<���쉎ͩc��	�U�#ʉ��'΢����r2pB��Sz�8����F�8Bi �:$Y�Pn ��
���mh��dE}ۀ&$M
|Nb�����{�!>D!ND9 
��\���ǥ�{p�MD!1MY�c�&hE#�o'T-���Aǣ,� ���q/� "�p�: 2A����y �	��WU�8���n�n[���'��d.gATh�\������.��e�p��&7�`�9�H����A��3I���PT��QĠ�I��s U04�/3��L��:�S�k;��=|��p@<QS�ON9��`�7�PMP�iOz�{f�I�d�S��c�E��N�L��Ap�4_�9�A�VMG�2$΃$8�kY-��	�d����q�$����C2&)-�ݠ��t�G}`Ə�)��b�(�[Q8,�*�WR�&%jS���&yPTO�,ӱ�\W:��J2n#�&򠨞l�X��G�@P�%�-��T�!*�A�>��F�ɷ��w4�����r�)j����s�2%;+?�NW�����[�%�]�Y
+���F�2�@`'y��o������`N��&�8hU0&�+~���p>�?����HM���QU�n�R����5�FWi��@|�������4����rUw��?{�����ǿz��	1Sb�ǅ�?�K�i�=X~��\��B�� ES��rT��h�cY�b��Hl��8B	n�E��a������u� �e�x����$���uv٪M����0�~��������F�)�̻}Q�����6�*Ie�R��&%����/�A��DU҄r�@T�R�FR�nn�p��1��lQ�~�8YjN���d�&##G^����j�1j�j�n����w%�~5�a���w%�~W��W�R�#ԟ�o�kQ����FI��zؾ'���v�r�qͥ��������z����'�"�KM�K�r3��R ��0i�)+C]@�_UP̱���B2/�`}�\��Bc���_>��t���������0~�n(<�n�Jrk�x��N[3��m��*ki7p�k�&�S�3I��T��A
@�͕YئN��,LJ`Sj��~{'� �$6�Cǭ�R�
e6�S+!�I/�E��$�4
�Yҧ'���
���vǶ>�M$�t:Ȏ��y����;J���xiȌ'�7G_L4m,���ƛi���Tݮ�R����%�;�q�hл��}6���{g�.�u��I���dBOaC�E��F�6�.�?��j4�j�����z�$�^m�èm$?>��V�P�|��V����k3[#��k��^�ìqM@5�j7�f�jB��Q��Tߨ��H�ĨΞf����l����͘�e%�e��vQc �JD��i�VQc �Jd�Q��`t)5�~C*�Z�,ί���n�
iW&�^��Lo�,�d��*5dR3(?�f7�^,,�2���W˾Lg�W����vW}�ֽ�i�2ﭙ��
PKo��d�LK��_y��(- k<���K��T��8�tԢ��8�����9'QN�k�,�I�c��V��2����Mu���L3h�̒3h��m �@#jH�ͭ��A����I�E9���ۙ�o��AE��3�@"� 	��Й/�,h�%�w� �@@����&O\�?D�M�p�"��$��rV��I�p��*����fk�lă&x�q�?�qM�D{�A��(	�t�Y��@<� ~���$xB�/	,h�'�}�MH��'���_ 
^����(P�f�P Q�$��h�M��$CDA��.�.��&K�,��
�	�,'QH�&�z�K�����N4� �����ٛ�A0$�2?�8vEP$�?�:\EP�t���!�"(�Q��G��P�����}�"�L���p�A�-����tDE S���l�A��(������`�._JY �K�|�c�p7�n���q	D�5=�n`%KSz���Q0DL���]�,��)m� HQӓ�ˡ*��K�}BY 	�I6c� ���IvՕ1U�)��ffY0DN��ed�YȲҝQ�F��tg�ga�@2#Ŵ�9�gP���[�E��2C"C�d7N3C���=�PՉ��8� �x��(P�D�ȳ�B�(�DP�gZF7"����S�Z\�q?ZGY~���R
"�s��x�����D���9�Q����ָ����Y���p1Ѽ-jIs�4drx�3s*皓��-$QQ5� Z��`�iЂL���L��dE@V�Ђ؄[D3:�A�[���́T!j��g�F��f�>I�U��D!o;�3{ՠٓ���ѐ(D���LBn`@
�'n ���瑙����m@
"�s��4�9:ՀH艹���D�of�� $�o��[l�@���=1)
��@����f�B�^��Z���~}�4��hx�4�Zco��a�r�|�&�*6N��1)v�g7�<���޹��JZ�?��՞M*�����d�$�L�G�$$�HS*I�b�O�����*%�7E��Rm���>�.Z8��̯ �Ƅ�QyY:&�}�<�t'�[�D0�.�\ˈ��I�q$10�a�{�b���o������#���ݮ%|B}�q����̋�w��O�r58E3/�E�b�,�I�VUKv�3e1��@c�8���a��o�����3T����ہ4U�5�[ �,I �͒z �R��A�d�%k��]�A���B�!?Z2�
gc�U���?�z�n뼪_�b*��9u� ����~7JژNv�eg����}F�H��|	�V�+X� ��,����[`�$���H��隞ޒ҄5MH���/�h������k	[�(��|OYp��/d&�'�ƒ��/�[?��O]�0yjj�x����<��΋��z'��y�Jy~�r3/�`�\|vū��]�����Ty�=�`�rsB�������:�֐άw�YSU���i�,�T���[?~�_��"`�px�.�/ˌ���Ge��|��ۿ{�v����7g{�^�p������ v�fw����k{.Y3Sۂ]��
6���69;�����L�ls�T�V���R�K>p��vv��V��`-ɡ'e��Iْ=��x�!��d�U�Jc����V��oߕ&���a����4��=���i�OZ�>0O�mƛwf.��B��l�n/� 	R�S� 	���<�T+G�SŜ�s�j��}v��}��zoz��k�K"�(hYGT��E
�Tʂ�����v�Mzoo/��塩���}^"[e�*R�Bv^�r�˂�\�DH~�4� ��K��G(H7��ME�͹�+d]a*l�]d�������S�֐n��>I��"�*�m��Y�I�r%4��:P9O,��]*Wd�����*X�
��I�BY76��u��p�gY�����N�]�5�	Ve��;'��t����ܷ��?����4+��-_9�{uXA\�
j),I�%Y??���~.�+���xM�<1��;������˼�/�td�sq��ݚ1]�~�fx���Ҍl�ڌ �p������4�ݳ	��\4���F�f4��#�j�U
"�J}9�~�д7���4������
��%��=;Eԓf�Q6�\@�}��^���[ ?��Ϊ�hS�uy�}�v����za�v���2I�8-+k��/�\�����������*Hh�Z�!�bU��c�5���p� ��1,)�sH��rdL�Xw͕��%�X�x�%s!e�̷�.�Ȫ�c�n��,�},f�"��O,a�t�ժ% ą�:LjL@b�X������@-����@r    �xG"��4HA ��x#h	D�o�u��t�����w$N���M!��p`	$K�D�#���.�%��Ib�
�H�$�1���$N� "ޓ8I������d+��\D|��{8F��p!�m�?Ƙ0!"�]�] r�b!�} ƤŅ@��H ������@��bē�K�%�"^�R�R"Á�܅Ԓ�a-��]�D*L���WMV�A.�-D|���0�"�]_ r�� ����"�]"�]�>G��w�*��J�Aī&+É�]<D�J��
� �*K�s�x����ra"^��?�����s��]̄���:�xM"���.�%"ސ4��d�c����d�xϲ"^�%��0��xM�Jn}�!�5�˅Y��k�
� �,���@��t�rۃ#�,8�0oHr�6pF<I���4�:�D<'��B ��xfV��;w��,of�hW��'�7�s��i��>D�UМ11��� �3���~W���M�#g����M����]���d�.�A"��Zs� rk�{�K�]��~R��]��>����J���,L=/NX�L ^��Hw�� ��_�jI��b�uă`ēle/73��8b	υ9�$E!�tW���I�{��O�D|�<�i���I���$�C��@��ANVD�!x��.������VTJ`�%���e	��,��.Qƈ'�]�yǒoI�gƖ�4&}�4��oi�� MoZ�MD- .�;��@�ow]2j�i��L�!�OdA0�ͨ�t�܆H��?�s;/�W�A9R��p N�
?�#5N)o�g)B��<kƃ�
?�#5�B��~ k0����A �#��8� {z�ĉc��q�V�/�o�����$oǘ���D�9UF\D|�� rc��x�����u">���,���/���$7�X��
3��X��D�Y-��Od�m/V��/���Kq-��Od/�]�2	�	D|$�;tX���h��V�E2�sj=���H�^�-�hm�����񴺼߫����t������A^q;��*�z��dk��$h���kU����w4�h�-���ֽ@zz�M�K��� )�7R�¤$�Hu�J��)���!�+n.��]^)Ի�ß�������k�o��?��w�u?|�h���j??/��?|}���5Ņ?���]mr].��4��SL��/��ӭ��o�V3{��}�f}����
Ȑ��Q��YH�K�$$MHN�䀤Ҿ���<xD&��0) )���E EB��$O���E깓��A��P��s��������p-��'�I��(��M�N��5�]�B�/��ݐԾ,��Ց��@/RӋ��5Q�P/�r�����4���E�$��m�Ȏ��u݃FdKH}�o�zЋLf}���z��L���*d )�8�x�ݼ*n%AD'��u�Z5_��aa.�Z�A��ց�tb�!�b$$�j�t�tb ��'��4	��@�c��=@��$� ��8I{o K-<�@�O���cOR-�{����x�F�Hl���A�\I�@#"'#<q�)r�\�jC�B�L{��uӶE�36�@�޴1��z�bG@=*���Z_��iw,�M��Z{vZ�Ό���u�����P���¨ �@QaT��Vr���)�[��u[-50��/}3��]m�IQj��Z˫�ԾnMl�$݆�:��z+��3�	EFӆ:J���^��խ�����2�v9n'5 5�ڐ
*To�^���&�&G����Nj�pQ$\�^6\j�aC�?LPF�E�Za�M��AC9a���(/��L�P-�*��L��L�0dQ��d:џ�Q��(+�SdH_�����Q-4E�(��L֩Fz;V�������d��~�Ae�i�@-����+L�@e>^�ZA��
�s�*#;7z�"HW�6	�@u-݁ ��������ٓ��X�b����8p���LѫL��D�BM�!3z�\}]Х�˱�k�9��;�9�+u����~�H�����T�xz��J�pР'����ti�EgO-,��D�t��^��@�ka艂�(��אT)�_�]AxI��]C�D-o�(H�eW��REa�0�46��o@-4���.V�q0�Y2�q�������s6�^)�沱��ˣ�K����e���6&5޼�ڛ�8�Xۣ잞R�3�������G3�s�����ȔT����:�~Ď|��>�på�3��kuO���o�u��_q��S�\?�o�/~�|�6�i�m+\���~�0���,_P>��>߽-��[[��{[,��ncTk���m1�-'~���C[������ҿ��w�~�W?��V7 w�ӽ5B!��bI����%A̤��G�}��x����O�����a�55q�SI�]ǁ����!�{���n��p�ݸ�Oݍ��D��w��m���%�sK(u�p�;�~���?�7����G������`�=7x��X՛gJv��0}��c���H�;�uwL/璉Sɻ)��TwSJ�Ji���p�1G��DԽUۃzfE��p��`*i�L��Ӓ2P=3�����(�d�H�r����@\G߽-�p���wo$��n0	���ϥ�^/�*~pP�Lb�IWڡ^�x��������\Ⱦpb㤺+�I�Sw®}�d����{^�麟�\�_IO9s	����S�2Ŷ��v.g��]/�P��΀W$�zC�,Ps��,���Q�#�u���CbkȢ�
GFk8t�[�h�r82Z�A�:P���j���W�rX�P�$'�r﫟ݼp��2O,˱�A�s������>�;,�����^��^����²���݊!���KIi*F�"ݼ��'$����f�869 �F���%y )B2�${�z_�H���:z�5NH�x�&%�=Gl���R������ʜ@H�y���;��P#�I8r3h�&q��	4b����^&�F4���#rY$Ԉ@H��A#L$���5ʠ&�:"����jDT�&wf���L�ދ+�$bo�`��Gi�ē;���������{$$OH�
�B�c�':4���A�FؖGx�KZ�	4B����{P��D�ln�U#j�P��Kx�/r��r�
q�D5���1?9N�ejS��&�F�t��|�&�()�F�S���AO�8��6i��H</�� )6�ey�Lr�[� � %nh:��q�s@j�1𒗎��Z�������9�,�I��A."uCVB�,��j�`H�����b��HZ#�l*$���ey�y�F ՠȚ(r�,�Qdc�d�7]��R���Б8��i�Ⱥ8	���em��]1�Z�^�{����=�8qIH�x��>S͞()����&�;��`�y<W�-��7=�S�D�)�mu�%p�T�B
b��y�-S^)��K��Ӗ����đ~�m#�sI�8��ͦBz�HFɋ��b!Wq$�<t�cg"k!Sqd�q��uAz<����X��Z����\p >��fNq�O�K��p��V�㩯�:rZ+��Ձ��6n��\�8P�@|�7ſ�'Am��
��bAm��UG�rP��@V��M�]2����W-Q<$:��X�m�+t�W=L�[9��9[xКv%^Q��>�8��3E��,�w�A`"	�5�2l�uQ&���,��~��.��l��.�`]��y� �&��.ʤz��.�2�ȹ.{��$$r2�˾:H�w�����#�a�`�$�����j�"6ɞ� {'���jĲ	�lш��xpf�����xp��hM��YuP���F�)�JSyny�TC�*��R�{M3*�&�>T �~��ZQ�nAؿ#T}(Z��{~�����Cъ#a����ٱ뭢Zٱ����P�M+$� Q�C��� ��d�}�����k�D�{�³m�"��vޚ��DtdW8�J�ADRq��"���B���u�������$��{{��G}$�γBB� �ok��O�Gi�jw��
	4"�\��	�ahD"�
;r��/P=�YϰO��$����gx0$ЈD"W���G}���Y    �G}"���k��z�'��� t�tшzt?}��N�$`�!�y�:)<3����K����ߌ���|7����_=~1�n��҂�v��Ԃ|i��y�M�G��|�OM}}O�x}+�X���k��
�F��_u�P	ޣ����.��5U��]���.��\�xi�a_���lW��c���W�W�+�ۻbY1�QTUZ{����\�E�)�n�W�ؗ��s��0�S�i#�Fr�$KI���z�7saS���8՝6Xn��WCl�,OH�
����u`��u�n�����T�ڨ�P��E �F�Ly�}�e��?jS?�0��=�v:��j�˟q�R_x���7��zž$�H5W�$MW7�k�:��4���(L2@Z^�<��搦og�8��U+�	'�f�a�[�99�ȒQ�I��<��MQ��Ԣ�\+/���G)�N���>�_��3�IΪl���c֨/b1�a��K~����Po�X�v�`�B5�8�������j�tk�I���-$#ˀVd�g�׊�;f�J�i7���(f�)4ґf$��H'a�7H�����@��&VHw�hr1}��J�Ƣ�$MHgY���!�ǚ�;HW���Vׯ�$�|�JVOa�alQ=ȼ\&����B�4�a/<��
�r{E�=k��r�f��`l�OL��:6}5(>�$j7���{q�WRښk��kk���D��ԗ��2ϖ���TW/xW�/o�Ӳ�G���OǏ��8���Ν2�Ns_��ڈYeƚ�w��/ֺC�̴�y̗nZ�u�߄��:�u������K���K�3�]��}���bV��H�h�~���i�t}c��� ��@�3$A@���,�h)Ab�k�y
jժ$lQ���~���c	��J�ɂ��u�4J�2�tYٮ�.2�1TUo��}�H,����)?�i�,�RR�;
&�^c(&kL��X�!%�V��`��v����r� �iJ�	&Hb8t�^����̇`q��2N�6�%�.��U �
8���5�U��Q#��nHj?���-�N����Mq59��1�5fZQ�Y�*@��H�@�$n�d�DP��K��N���
�V4n@	O��ikP�@\�vu�
&�
:�I*t�\ ��4��M�\@O�T���'��E���1eZX��$)��SL�����*Ё	��s��=SQ�a��:0	0�X��v`2`\�%盬 �5���58ts��U9��!ɸ�0$���4��xZ�e��n�kZ(��b�Q��H�a$S�*�NQO��C�4%����A"q���$*��
L��a@ʴ�0�c��@Z����4P�2-4�z�ށ�\ e��4P�L�&�7IA.P��͡�&��
L_�0m�cȂYgR�" �)Ipk()Xd�"Ђ��aE�Ir�$;MÊ ����#iXd26Zrl4�2��Ғ*�a_ ��SKj���V�eTLn��m_`�Kj��}�L���j-��X"6�֠
��-����k�F2n�L&. �ѕ��K�f�X�8�<�H��)��XIw`<Ő]�!�0�V���Өd@|�!��.rO�&H�T���Y��7�_W>�B.�Z�9'�"��D2�%��B.�5�eTr�v׎w�Ear�h�5��fጠ��S0�c�����i�;��B.���-���daE#��r$�@�b�`$��+r�V�H�X#�u:����$��T ��SI*�Hdl���@Q����@]{J�7T ����O*���SI��Ht�)9�x���SuM+*�q_���kZ[�`.��CKΞ��~�\�u��Lu��%�K��Nu؂�f_Д��[p�>�����+��w`}�&�wJ�]����K�oȵ��� ���.���{e�
�;4 Ark@}��ȴֶ!��t�C���Tk@���=�![R�%�0���@�O,�!B��� ����K�� %���K��h U��V�աV��Ի�껑�{�ׇ����e�	n!Ěڊ@�l#��u�ND-#��)�e��L?%�`J��q((=V��'tL�tg@��&S��3��R�k�N��(�1`�i��7�V0�E�zJ�nߔ����cI����n�k3�'��
��1T���;fi�ͼb�ͪ��r� 22��q ƨlv�����^LZk�vӆ�.���;>�J��@�z���ٵ���p2��\��\��`��a�Hq���%�I�*���9
�{���5G�r*.U��M�<�P�'Дe+O�s}1L�B�ף89�ʲ�.���Ţ&���62�%!gh@�c%�4 �tg�NHD��b�dЀD\@$1��K�dAȠ�x�H�M����g���ZO���1�0�bق	�>0�bt��oe�k��\ ��%&�w�� ,IĒ � �r��$
Y�B9HHh���H��;�x��4@��[���Smg�Ё�rK!����@�/�<�� �E��@�;Kd�,��'ݥ]�1�8���2�.Q��.�B3:�dj�]�KChFK|M�A 4�e�DN�4��ġ��5'd+��� L�vR�@��Cm�m��h�f:g�0Tɔf��ǁ��d:���P?��P O�@,���ӁgOΝ�f@<ӽ�]�����6�9p�Lp��P5Ț���!�� ������P���b�^0n@�̹��O r��� !�20��3(� �dPVnP���*,S0w&�bG��� �Z�6 ��ׁ9���B8j�_�	��p$�r��ᨩ{1t��	�N�"�-;�y�]̅,'P�����^nzt��N�aYn�]�@�l5��ɽ��ѐ����8ȏن�r�� ?6dQ�%f7��m��qp�$�>#�yH�ID=S[8��!Gv���6�<����e����*9��b�$���q_K=\�~����"���!�3ݺ`/��!������u��/�{�_^n]\�v��v�����2�2���M�P��D�Zw�x��.����\�T��
:��fAP��H5��,kQ�Y
ʭ�T�E���`(���t��]g��w��i /�TR�t���M�VF��G��?�|��Ǐ�2x:�s�p)��J���ƟN}�n�t�l�����/�_��zڄMhy����c�� �����,(�|��'�� �Xt���������ET>�i9�Z�������|xE�Hx�@3<	�$�u��	���X�%�D�7�8	�D�����fj�@/<�k��)�^�LzQ��E��E�n�X,��=ל>�^Ė�:�bzᚧO�ctыym�]wt��{(ӧ��<�#7�8ä��:��������Y�A$�& ٥B�HĢ��z"�Z�t��3�D"]'��f��H*+��D"�%wgR��u�TD�@���2�DVD�A���	y�D_�2c�����߾L���sK_\���XW�a����aY
�J�@S����
]��/��8���+�s�\���h��$O���n|�y�oxҧ'i׌��d����>�^Rb��xQ�*��@�$��I��,NV�I��hNvIWH�D��S�/���:���6Q�����h�8���^��f�Z��.�5��dl�V+�`�j����JS	�m0{��+����^�_�����{��]�f�Џ)�q!I!�i�ts�Ө��O��Ԯ����EO�ʓK�4�l#�IH���$$MzOz���=i��$�I���R#%�x2H�x�4)�xD��^�H�e����o��A�o#��>=%�a��/��X����'�/ߍ3�x���?�'�hw-���D�U�
��󂞾x-����M�-?�Y#i�!	ǁ�@�d���: 9B���S��i���I
�q
@R�u�`<���d2!	�������#l��d����問&ק�,X�1E�t
H�=���9�L�6i��%8C�����AґZ*0H�7���R�a/M��#�T`�-[R.$1��09H:�z�B�H�x$H:"�<f�V����˒��cJdY�aY[5tD-��<,K"�&��ף>�h���p�,�m�$��4�Ì�Ȍ!<    �zP�@�<H{9(D ^�\,0g��v��yP�||�17�H·c�&�B8B��m �p-����#�B2N�6�B�M����G�E�{"����׀
A�(�{�q�<"wd�,}��<Ci��/;����ē��=���e}3�l�wv6�z]���4�-����0�\`����2{�e~0c�`�vc2K7�ݍe�W``���� �l�"xcn޸��$
+Au��gj�0���>,܍I�����u����20�`�``���1�����7>�a� Q������.o �t�)_����l�[׻5�O  EN�Zmf����I��\����nA��tp�;ĊىY�/��?���܆���A�
�0b��ش�Q?1�Bre�{���lhX-�(X���� ,�X�����r�%c�z�nw�^�J�����|��QCt�ʋZ�
H"A�����JS�t&FI��VXia�]!�ށ�:��[h���b��9s%����M1�s&����b���1^'B����rYM�&�K��*Z��	�2m�^��[�Ĵ�uKh�s٦h�}"�Yy�נ�z�l,k�@���.�A7��;{.dÑ	�c��e�l�6�E~����/!VY�g82#w,1�,�GVa��4Ò�,�f��m���Y������8B�	pI|Y��%���
������c�i��=ɳ@-,Q���Y����p6�����.K�^d�Ȳ�_$��ȢV�IZ�,9w������:���$)z�4=���w��/���ݭ�����/����B��L�h�Z�q�0(��̩ϰ���6*THͪt�,^�Ò�����������G�g��ϸ����^%��ը�L.���rӰ9��O4���JJ�R=�%9u!՛�J���jpGs�i�{�$�a�'{�N~����tY���L酤�Ô��e����v&5�V�ʢ���v�f��l�Ǳm=n����08�M���t���08MI���2��������2Œ��`� ���8�j��|>�-�)�8˦����������=D�V^}mh�<n*QkґIqE�`��Ȥl��W��և*-����){[C�Jl;�}[�<'��7�m��8v�M��k�T����x!������u`GQs*X�a�*�CO���?$��L/i���n�ԉZ�@I��7�$V�F�N�u����*$�쁄�{�
�5q?Z� �jGӪ(���'B���=2Ϟ�Rq-���R'q���H�5���`�O�#X1e���&U�ZHE��H\Ig�^ ������i$�l�LV?�)L��޴�`���h�na�K(�Ȅ�M	J�L��J��k��"�'Y ��%��mr@j�jQZ�/��H��o��ۣ;�W0�� %^O*$�ϋ�jəE���9]3�%}��ؑ)�a4�n�ޕ���YiYv����+*�W-�Ѝ�t�cO��9�a-�=�WȯQ����U�ak#���a�(^Xc�&�'��[M�II!�R�+[��t��\�CdM��,󤢐����8��F�dIT����'�`>����߭Y�k2
w��!h�f�:w���B��:�&����+L��� �X��/̱]1�7X�3��	��n}�2D�h���T�œ��i4�ٞ���_�&�Ńd9�KJ�1�&5�AX�4��T�N?�9�'ӗ��	
�=��^O��Z���n��'�0�P�r�o5��f���\�I�:MWo5ӻ�=3��W����A���oy�����=f�'������!Ϝ�{k6��&QZ����o �t�R�M�\�C���Ԭ:l`�'�:D��2��t@;�ص)d.)\���3��7t��\Nx��yE��0�`�`T-�m�U��dZP�D�"s@ץªZX���"�d��b�W͠�Vf��O�[\��4d�77{���U��9WI:��y���&y 5'��U�]� $Cl�&E Yb��x$**6���&a6�I6!�{N��DFV�U��TQ��ޛM��}g��u��.�=�;D� 1M����t�@�HH�6�@Ė�MkQ
D&$�)Á@�6eL�=�$��DD/�r�Ԅ<�r��q� ��?��H� \j����&9ТD�H~��=�I_e�� Y2;���>�5ФFVD%�~��
r�i�RͱN����$�Mɹ� 9D��ķ�%��H�	�Q0@�d9-mՈvwYx����"�#J.<�ЇH����]"���q��=L���l�&�D�&喕E��@"bsrϝ��YD�d@��"�D�l/����YD gi� ����+}�U.4H
�_�1M��)���<��)�B�@|\X�"���pe��"
�ٽ�I(��dMJ�BDCfad�$z�IPkGR�,���`'�<n ���#[FI~��@'�)��p���(m ��d����q'߄�$��.��'�Y7	t{�"+ 5�p�Ĳ)k 5ww�is6@jQ�7��Y�v� �qr@r���=�.�r�8���^ ��*�{ ʶ�jDV$�z��6%�����>>Ψd�&���
4��`����@#��i�a�F�Xa�Fp�c�$�O<�����VA6��">��:��P�L���Up�Av�b��zVA�I!|vlnd�
ei�T�2#��%29�`�m	�%2Y�s���$PE��{�Ǎ&���`���L'� �LN�c�I($)�+\�P ���.x���$`�sV��kH!�q���I�B(��u�/�H�%9�H�8[-���'9;�.�x{|�Zk9��ڸ�d��l�����W��`A�O��.Ŗ��_	/��1��R:ٻVZ�XH�����k���Fk��;;�Zpy������\�Q���.��w���K6{��\^SY�p�X�.g�,1K8G���5^�5��2%r~��ra�{��l�oXY���J��'(�L���X(�L��r��<�E��Ds��ǝ�,��"S����u�� ��u�CAR&�(�&8�H��L����܂l���T=&An�Ls��z�&$"��-`6)���I�$�|K��l!q����+CV �G*֡D�fSǶ6˦��r&%B�=Ʉʍ$��^�/g�S�$<NK�Lҍ$���q�A4�w[{��ArY�C�嗙���4�M
(�Ԥ�|��P�T�B��&��~};��vK�V7P��I�� ����LMނ9�� �a*�j~�\s��'�������~���A,��Ĥ�7a8�U�����u ���B�&%w�j�� U����7FX�Mk|�X ��̊�%�����t��e��_j�r��˫^�*�&�a���8�׸�U`�g��o*qL�cj��~���P���!؁��qA�Q�;��,�bj�e�w���>�k�<�P-�+y�zLM^e;���,�bj�vޡ�M����'����΅�?��BA^n<��y>��D�A�VU�}�&�����gH�j��eoe�P����?yfYŘ���WО���,�1�+��o�Z(Ƭ�w\H,w�!�Z���{w�Z�[�Y��C�0�$�n��bL��GtdМ�m��,�O�\z�P � fn����~��JJ�N�H���$mH�j�ovr���܄Y���F.w�¯�9���*�}��A-f���29uT�0fA���TH�/�;��ds�oqӗ�8���䦝�_kʙ��t�� � 9����>��T��T�C�=��0�h��(`d�/e֯����tP����b_�^��e�`�=Ɋf�Ь��Z@�W09(Ь�[@����M(������&�E�J.��V�0^�I��d����>����OZJ��yҾ�� �x�ˣ�WeW��u��4��{=��غ�^2i3]0��ř�!L��]���(��Z��ZQz�G������9~1��)?�s���s����ZQ�Oǟ}�Y�"i����*�d�4�~Q�?��}����_����4a���ލ�<~����������4�7E�~?~��e	Z[˦�3�e�2�,���7n�\ݹ�,��u�    �6-Ӵe���-�o�gZ��-����3-3�e�n���٥e�z����2�����}F��n�_��'~��S�/ӏ����3U�Z2z�����hl��֠)�S���T���'��J�JS���H� �T���^�d�ߓy���h�'��6~�,4ȑA� ��mA����ih���L��V���N���+�� #z���z�$̪��O�H�1׬�s������P�#�c{�	s���ۘ�AOqq��� ��x�lΧ�X��� �b���-hG:��A�I��7�-@��6����m�xM����m6�m�c}.) C�8R��|IOҗ���BH����Lࡥ�iq0w�6n��)���P$��h�j�C�$A�BS�ԡk��m��o��������-f����-h(}d��<A�|��l�hhA�"��9?�'K���C�|��qH�'��1�G.-��y�k9�����c@ґ��'�ձ�m�'���k��sD�:D��Hb�F�v	Ց�o$�	��u�����4�
��1�����:"�~��:��-6a2
(���tv������o}ƓAI5��b���L�DR��*�&6ݎ	�h���"6ݎo���D��:�z�%hP���Fs�Р&��m�~�4�Xm �^i�5i�Kl>�w��68�����A�B���H���f/�+(�
���ܱ�MWAYֲKV˲�v��
ʲ���g��&-�P�����|�AYֲ]Z�q���1q#�sj�O�Ll{��P>I1\��m���DG�ZֱY�� 4�h�8>K]m�uL���:��M�H16i����]��p�(b�����j����t��>�j���6�p���QEҠ7Yx�p���v((<`SG����a���2�mР0{��оM��z��ѓ��o� (tH�Ы�B�Az�Dc�B�� ��6tl n2@Eu����o���-d�����Φ�Ļ~�j	���V��`w'2vo尻�[����<��o��~�����9����ی�C�%��7j�n"���-2�A�q�/� ��D6H����;�<#��1�BnN�;��/2��=:�o��ז�G�y�?c0~W�����(��8~��W�=�^����U��C�)MЗ0�z��������K�x�a� �,��Cჺ�]�#�~_���W�����	4���foX�w{ݘ2k��i�J����E��!ϸ4��P��/��k��e�-syo�"ư��vNo4��z4m�v���X��:��k�z�	��C&-�8����Z{��t�ih�5{�Q�M�GhY[x��"�mZz��-F(���� ��!��7o��p r;0��6-C�"�W�po�2�\Q�>�@���D���dc�~ �KD���2� ��!�s�a��am�z��;�Lk���Kkn%ΟC"z��ׂ8�h[GY�6-�ID;��6h��������7�f�ʖ��IwE����t���v�� ��!�x�SߠQY�ܷn愤eo|mL���[�lG��5Nʣi�c7��pR��cG�OKГm^��ħe�%ғ���<�Hzr�$u��[g�p�u���:�GMf��$�A��-�-h��%�qw�EM4�/p�]Td騺���"z�q
ȧ��)�k�q�ϦACTM��k� E
QB��6�(�V�Z�Q�S��Ƨ���j��:�a��AΥ�j��pp���ʗ\	i:b~����i�go|�`��в���Q�}e0@�Ah��0lPk�� ��p:�{�4XE�1�������Cǎ1�kӖ���������/U��$凖���w)�4Ш��S|��ǎY�O-ik�a�P9>��eAðŊ�m�?��i�%�h�k�N���Zto0np�\]�5/��'�:�`��t���{��4-9n�+{�	m/-1������c^Ҵ��l�1/I$�6�I�*�gB�؇a�����%�7^I�����}�ԭwU�MuP�X�f*�J���--���Rm��?��4�Զ�V*NB��K�p-X~�U�ƛ����� ��L��7~�4�%�>����K�BA�����^.��L�o}4
Eq>�������
s�᭷S�^ H�ݱí�P��3I�;�
�S�(� �(�}&=���n�hj�a*�	�":�Q�§AB���m��wE�l���0(�Q[$��Dw6�):$Ԓ@�d�`��_CR��m���gb�[�!��xE����o~J���]�া`��;�&v��5|�gҏ������v:n0h�9䮞�Y�2��.��nN��ePn�6�7��	r'�鴁e��#z�ևPX�O��9�9H�o�pz�WX�`� �(�[SX��lQ����2������`�%n��e0捿`� �\�߸0 *3rG�~�ݢ����X�7�-��j@ _��o����Kɔ�&G|3��I�m�c� kI�(��pi^���cǡ�Jj[�q���+���L�Y��+8�I�ͥM��-9-�b��J}G���gQ�qqGV��yu���.B�}p$h��Ң�q�G�{/��P��ul��$ˑ�����@�	�>	��jG�v�M�U���%B�f!�z��a�-����=��k�hPk�`��${�^D�:Bң����ҍo�1�x-��oN)]D~����N��˙�d���|��ی�x��?Ɵ��?/��]�_+y�oߍ���ڈ�H��~����ύ(^�4�`�FhhDn����h��a�����>��1I#���5�ݱ�6�j�wlD�� !��TL�a��TL��~!�P1�;6�8��~��P1�O�;6��D��p�b�q�cO�b��������cO�b�5w�	PLK��|�F�b�����A1�	}��𠘊D�>�F�b*2��1������w����A1-	�|�F�b*�O�;6�L���!
���Z�߱'�\"?_�S�S%�/=b�N���}�D�I}|"�����ǟ�?1��������n��p�����ͰA���p!�<��ʃ��x� f)�8�6I�4�QXL,o�`Y�)�����7F���4,RXYh]aZ����ژMӠ4,C�5�6p��o�4��o0f����6��
��L�ە�����`xcD	MA6�
H7n፠ ��Y�@#(H c�E7���6fq��3���f��`�*�m
�A��IA�F�k�u��֊��O��J׾ �x!�c����I�Br�YaSN���=I�,��B�i����[�Mg'�$�d�� 65R��HI��p&%��I	lҋM�H�2��z�H{DV@j�g��)�F���A�d(�V6_}�I�,��j$i�ˠ��^���<k��V�d:�s�8��)�2��ʜ�i�8��i��]���F3����A�U�=���Z@�^�=��t�T�P�n����&EiX����Ų�8�6�
al����6hm�#>(��n�d���o��;���-[!&�tMM�~1u�����%�J�jj��T�C��b�/Ҧ^%�f��)�l���5)�-y�?�GbR`����4F�e�"�cz`�1�O/�-b4F/���+a�V Sm̶����E=��<�0*5�6j
�b�l�8Ө K�r��F�J>9]s_���\���k���UlҠI�E�ڢ�P���Rm 4)�T�l�hФ�4�lэy����7�їd`��pa��&�������V����n�A��0��t�R�{*R$�����i��Z��00��p�u�އ�v����P�mX�Ě�2	��5���l��������gXXӰfSk��/뜽3���_F�7�u���`F�>��;ID����jќ��ݮ��_"��LW��C8�1���)k���%&�����5��
`��\V�҅r�YMY�~��7le����t�u�ff�m s ����?<�\��,�С�NX����
i�@?tj�-�D5�y��i�7j�
b�e�)sڢ�A͔FR�++�i~�?��    ��(3�bW�{p��(�[��@>�G�_�*� ��K��^|�t	XK��+�c�0X�d�� �=,i�k�Wٚ�{T��C>��ɾ��Y��ɱ�^1m���drj�&뗼�x�E*�
VK���ه��7F�ǲ�,0#|���A �X�
�+�e��5���L(��PN��G��S5�?�L���������o�a�і.��R�Q�x�%�\��0�p�U)>��F[!�0}�&���/���������h�C�)�~G�E�n��A�^��j
�t,���lq`�+s��7��5��!����"�;�b����߰���>MGd�0��f�� f)�.ˈ��F��`[t�Xn0�,���K�"���L�VҰ0�,;u��ւzZh
�(�m��>�XݘPA|��8�Y
b���>��@A\S��A�%P�$ng	�5��~�MAR_P�`� �9H��A@A|���EP���� �o�a�2(�w�APgT���s���3u�*�T��k2k�c� �O�x0��`[8(�jB������&ĹO�y0PՄ���e� ���{yo�
D�1��O1Y��X�]�+HV� ��� �d
⚂��)��Ĵ�l�O����mK�A>��
��,��|�(H;,K��
�N�� ��d
Ҏ��a�8Ӹ��,o0f�$�t�Fiݸ�vU���.���l��������3&kt�|z[�n���`�UHY{J��B:���u&���]�h**~ry-�M'�e	P��^�Gg��e�ȳ2���2,]/�,]�r��r��Lm ��6��V7��˰�/��ogCVR|��>��~~k����^,��+�r�YazC�+�v�~�i���b� oY�E��+=_�Ri8�*��X/*)y�������t����Z��Bݚ<Mwq.�0��Y�(&�fM-X��x�L0Q �(���q��$&��hb� ���i�x�d�M7W�N��$]���/���UH�_��Xw2���uC�q/��{� �=y���b�am�uX���^�(�(Օe�I����]�u�J镏d� �՗9d��
�N�����>�����Xna������҇�4�� �M0k�8��������5�0}����w�?���x��^O��D�p�$�Φz�]#_�>�x��?������/�_��33���.�wq����𭂗.]j��M?<����ϞA!�K�X[��(<�㶱�ѳl=�b�	� A^�}1��Բ��\XÑ�%��kva��N�C��\7Q6�lG���O���6x���� ���|����,�CTj�|FEE�C7�M�,4z����?�����_=~���:��5K/;�$��6���Dr�����1�#�.�CN�?ܼͮ��چC��D�LLJ|����t��NV �D�Ho�@`���e�Y��#W�d~����N�8��!��~�5J�{�����xC���|�����U�K���&~ŖMMQ~�˺s�J3q��Mh��X���T�׵}�F�v���xْr�`}C��:)]�I��W�=��ӧ�z�~�鸐����rk��e��/8D'&f�;��$<�$�W��33�P0�(�P�(M� ���i���չ$9�|ۼ���:�&R	���u�>�.l��lK|m�n�J|�Y��a�<�3{���*�m����X.��z���,�Fq]#�H�E�W���f�8�ŇTH����o���\�^������8�݇�D9���f�f�X�4�"[��m�p�gQ{p�c[}�Im9�a��tC��E	����{���^�@e@��:�ξ��6Mi��=Sߘ�&��:��<)7JA<��XIv-`���Uj��9'ٌ�(a�Z���^���a�,�S�ǰ;����ci�n����W�?x���ŉ���=;Ʀwb����ou=4.�vwʪ,@r�VYiW$Wl�ӗB/�����|��K�n��V��+�8������Ju�v��z����>&���	�,���t�#SKB�H�P��j/�i����?�(�_��4~�<���g�������O�?~��=���?��gM��iV�����!�r+��΍�j�ZϷ>�ƭ���M[��!�����٩iy:������MsP��@~�ᷖ�������#����G���*��h��N`u�':S��k�=U[-V�{v��0���hn����h���SWz8�Ir�n����7<j��o��'��ZɒL V���&�eE`�%o�A��������+�o�ƚ�@$YVK7ּ"��Ї����J����˷������"#��똯�|:f�]�^M��{�CZ�Zpg�Y��)\���<��(Q��E˂�$�r2sg���{� ��!Ih�}t�A��7Zz���`�.Br�ä��Ё��&�Ǥ��ہ���&� .��b�-����}�d5+��� ����r�~x�X��\c�j��^X'�ʁj�6u�4�㯬����M3N�$|�8>Y�d�eyL>ږ�щ{�G�hv}���uՌ�]��aQq����WL��|�0w����:́Y�Ol�ʃۖ�j�<8�=8�[-��f�i������������Er�ѵb&.ڒ|�O��4��� r���5��x0F��w<r~����^Zrp����,��	�����p��Uf�m�t����Ȱ�aR�>1Z��\h��g^�̑��ӵf���n�M��?�_������(2�O�M��Z�vBwi�V/��� {	��[(��K�@m�W�P��ݕ���Z�-�-�텵sΕxh�c9��	�U���Iim�U���s�W�};71Ο_�_�NV>�t��fSK�������m���Ģ%􉌏N�>Q���<1<��'j�':h�x����"_��F��3Z��3F fČ��1��P�������~���7S�om�j���X-�9���E�:~�PKh�L��>��8�h�Y�Q>��������J��ԯ�z���ӈ�h�
�ؽ4�<h�_Cj�}��GS-�O|O�����?_�<�>�<�ؾ�T�M�)CCVT�x�O\2bf�bF"
5|�S1�q��3Z`�5�/c�!f����-`�D��33P}Y�>Q@5��������G�1#Џ�%��bF	Č������!f8���D���P���,�5(�j�6b�0�b��8�D�U�D���>?�����'x���e-��D�Q`���6J��cVX}b�6
�=�ƌ���O����3kOt4f���@N�0fr\Gc�F��q�;���ј�I�{\�'
�3.���A�D�(t�(3b&	����F�(��(��cF�j��(�b&
Č���1�!f�@�x�� 3cF 73Y`d��c���� f�����,123Y@{�LО��R��,�D�� ЏcF@{"�3Y f"�31!f�@�D��$3s3��Ƙ�]#��\a��3Nbd f���\��/���AJ3N@��g8秫O��qj� f��X'�'�f	b�K<b�
�Y�= �~��᜜�=1�<�99[}"���l��0�pN�V��1#��b���1é/Y}"�L��� 12����s��k� f��k�Q8ϼ��1�%�1���2
c����(���jf�3�3FA����u ֿ���^ f4ƌ�XC��x�X��������,��|�':x"C{V����go�u ˧���������Y� ���{�'fx������J]s�X�l��O���x6bF�*���
Sc f�쌁�ᬐV�1#PofČ@M�13u{�B�p2��'B�pN�V�1��UX}"��$w��3�ݙ�'B�pv�V�u ��p-�3���b��5�Hh�8N�֏�g8��1fr
1#𖀁: ��RV���N���D�	�: '�5C�����3J�j�p�'����yF�Z�x�Nm��1fF�c���=�3���Cn&�6��0�Ts�@��3��&@n&PnČ@}�	3�+� 1#Pn�f��&`�x�Tp�e2��Ņ����    ��]��_�2���w��,`��DY@|�>��>ї�d�V"3����O%�� 7�<���^�b���F�&X�(p`��x�`�.�ȵ^�����B��{R� �yM�0���4A�� hF�MƁ{_y���^|L��	�noHO���.��qe�e��ews��F�~X�j�T��2 n� F`e���=���h
�7��u�q0HO+��{�!�J�Z3��V�eUѬA��2-�~��<2N}p3y}UX�w-IR5-�f&->�Xr��'kA.�x�c-ȥ_��o��*s״h�"���f��1����%��>�S����������0{��s<7�=��~�r�u����s=}��ko�~Pbύ�^�qKп����3>7�s�T{ƛ�?�5bϽ����9�y�%��{�"�u�|X{���ʵ7�s��,�s��!�s�� ���-b���o�xSb�}�5#�\q|��W<����S����ވ��\���&�\�ݜ�l!ڼ�l� ڬXV� ڜ��%�&�_�§B.iż7��f�4'y��9s�"=D@0e�!�;	�+7��+�Qd^"��+:#�^��vf�� ���<+��� �0�u�ي�e��,?�Z{.�yV��`γR�Po�ϕZ��z |�]{.�[���kυxs|�Y{.�[���k������S������ҜM�� �Ĳ�z}��?h������B����=��H�z�Ǌꎘ>h�7#��cgf��8��ś�xr� ;(J�!ޢX��'5�מ����7%�^�7�q3��"�o^,.��狵���&6_ܱ�I�!��t������c�7%�g�71��o'}kυx�8�\{.�s/��\���t�B�u����A>����$��-�����-����xKb��p�&6_8�7'��88������or���9��x�b�x�OuXq型����z�7���Zqr�K���Iŉ��b�I�7��$�?`�I��8Ir~���`�I����s�\l~�ߞ������S����n�p�w��Y���NK�g�'C���k��?<����W��ߏ��_�_<���������/�?�x������/����Q�/t(�1���ן���.į��+�9��뵍��q�;��+���:����}���^�@��n�F��+��M���N���gp}����]��m���f�k�3�qme�kF�1| ��n^bi�q|�e��2=dx>��F�lw/͎����X�au��8��|��Ȱc���v����Y}O�ôe`wá^uu�|���.�����?�`ԃV����Knl�ѻp�5%WG��Wdb�`t-�������O��4�����4hY�l� M��f� �L��͠\G���4��!�k�#����dO1GA����^�ZB�m_�SZ�I��˚[��IL틛�a@/���� �k�C�L��}�ʹ3�vg5���1��̽M�mǕ�7���0Ҍ+>��^Rj�K�Y ��m��рm�g���p����U����F�@uY���(�����Gf<��2Of�x�����K�wG�XO��xc��vڲ^�d+��ӥݻ����1�g�2��i%�E�����x��)�|��Ͽ֯+�d�������t��C�8�oZ�����W�߮�<:.���:�C��c{�'onٞtnO��s^^Л؟lϳ^P���qdz�9:�!�[��A���RD�u�	7���2�ܐ<:t�qP��o�c BHZ>���1��!P{�i{� ����x��-Ǜ-@�����X��tkY�-������Z���w�7�̻�<� r:�����"��7�^�@dRK�(r:���HË��]"y�H)sDC��N�؛���K�K���s(k1�����/�t�j����������������?����ZXd�z��ۇ��6W8mfM�"�ķ �z}��Y��Z~���ZE�����t�+۲ZDי�Op��/�������q�˿u�˯���%���g�*��S^Vcoۼ����ls�r*'(�P9C�	�c[ϩ��E���R�S�m2L8�3v����ɰ.Tâ��`�)����a��Be2L��0��/,�Ge;+ǳ��������P�C��=@م��,T�PNB��(T�P6���ʧYR�|d�ٿ|3���}H���S���\��Xѯ�/�9�)�+_�Ku:t�F�uJ�����R�5Y
ߵ�q �|�x��~�r{��^{^/��hN��_�)��!SК<K�BfqJ�������1rj;e؏:����J��	�k�tVJ��R:B�)���R:C�*��E)]N�C�7�t[}�$eҤ�+�;:\I��n���i�t,9��,ݏ���w?�����U���D�	�Y����"U�j��V�j�j��A�Ϫ�}lk��V%:�TD��`SQ��MED�6%:�TD��`SQ��M��
�"�(6UM[��5ؤ��F6��R�Pհ��U�K�P��9%8T5�z	��x-�"rT�ʼI���&�{5�I3�#�T�`S����&b�!o2��l��MŐ7E�l�"J��ED��M=�z8�M������x�Xә��X�%U[��$ʛ"�tI4�F�)�"k�(�DĚ.���7EQ�$�GQ���$���EyS"�T=6E��ElJ`SV��G?�h뇽.��[{���_�m��>C�C�M��u��A�̐���	y�� o�hj�������T�(#e1�$�;�*Ru�,&��)�����hw�,&�έ�ù�R�&�)���XN�h9�`SPQ˩ ��
�D���MAĦ6�
�Dl*`S���M�x-�����MI�#�I��țT��.���#2��ZqD���8"SmW߫6�+��T�����5�jC��L�!\�&�v%,�M�/��&QÒ�Ts�d7Ն0,�M�!Kv+"6���\�&X����0��x�\�KВ��x�%���ѥ�M"�Ò�T�!�d7�n,�M�+KvS�2`�n�]iX���2Kv�JWZ�E�ҕ�lѮt�%[�+]i�Y*-٢}�JK�k�JK��t�Ғ-ڕ��d�v�+,�M�+]i��JWZ�E�ҕ�lѮt�%[�+]��M"6ђ-ڕ�ƼI����"JВ����9�h%Ya�v�J�Ғ-ZIVZ�Ul�iC�%[��D��ei��""Ғ-�o��dgQ�FK��z���,b-�Y�&Z���M�d7�U�
Kv]���{�x]-ُV�0�-[����ac�N3FW�(3�#'�5QA���ZS�י�5U[A�{uT�5�M�n��[5_���T�5ߪ���&��S��v��㻉J�TgF�z�`���Y�㻉
�U8���8]��U���n�����&*�X��n�r'�0o�s��-��T:�E��
�w���Ň��Ca��./ʸ4{��}[��jl	SZ� 1��j-�� 1�]T�Č�x���po�����!gH��].��J �ۄ[�"�mJG5`pFt����$fDw3Ḧ�!1#�[�Č�n3m��=#���Έ�ƹ{J+���}ʈBY�)swGt����8#.:�;Έ���3FTGt�q��vFN�$f�z�BbJ\ 3�)f��eBG�.���{����{����{5,�F���$ڄ�^-��Ą�^���ĔA���M�iW��(1#�-`D�h�a�N3B�0w� 1��yJ+0w� 1d�y@�y����ú;� �aݝf�^�ܝf $"�ˌ��iFtGF��w��N3�;"�ӌ��3���qFtGDw�ݑs��E�Zjb��	�y�1�%d�mF\$Dw��.�> �{�S^7��Li��̘��L|���m%0w��"s�=#�2����b�巕@t��))33�1�2�n�1%eDw�z��S$�>�] �}Ft;��gD�#�}Ft;��gD�33���螑p:��3��9wOi�{���gF������
�,S��,S��,S��,SVIn�)�$x�ʔU�je�*�^���F�ڔ�z�ff�jSNa�U�a�i���0�4    z�ff�j33�^����Z�a�i���0�4x�ʔ�`x�ʔ$^�2�x��U�3L��#-3FT�GZ��"�����Ĕ�R�}�}��pT�M�K�=ζq�͘U�h�3L֭3�1��h[K�M��?e7��2�n��h+3�f��2�n��h+S�t�M����VfXb{`�>!�{@tϰ�u8���Y���θ��h+3��;me�����Vf�j:me�����Vf�j:me�����Vf�j:me�����VfYw8��[M�����w8��[M7F��w��a��p����G[�a��p��wv;me��@���̸1��h+3n�t8�ʌ3��2��L���̰'w8�ʌ#�Y�kJ+��6�p����G[�a��p������p��Vf�j:m3Γ;me�����Vf��p����G[�q����Vf�j:me�����Vf�j:me�����Vf�jz�{Ftgf�3�;3�g$�p�����9w�h�3��H�֓�]?ա��E_~��Rʢzg�N�����~�H��M�Ȑ��<C�@"͐���3$$l�D�D� q���}���$�"a!=tԛ�i�,���h~J�!�Ì�/�0#�>����3� �Ì�/}��P��E�j��6�;�V�^8��>�r�X~����ݲ`w?=��v����/_.����7�t��	��ғ�%QOf�F��CU��ZƱZ�H�"B�H�A��T;��L�C��jSA��4�'�os�4mm�'���,�Ad->#�j�Z|FٰL�'��%�LC�-cӯ�9������8�����o�X��k�����f�Nt��A����,�R{F�H�G� ��;�� ��;�� ZLt$-A���X8�hJ!`���t��
,�"cQ���I`�B ��Jl2ɂ*� 6%	�R`S��)� 6%	�R`S��)� 6%�lJ"6�zEl2�)����&�*ؔED��M1Hr�Elr�*ؔE6�)�8l`Sq8�MY��6e�#ؔE�`��"'�M""F�M.�s"�U=6��Ml2�"�d"6%��DlJ`��ؔ���)�M�xMd�Jud��2�T�*�D�PQ"5��(ѡ*�DPQ"TE����x�<�W�5���5]��([�`�ju��&��*�M��U�T�+�T�+�T�+�T��'�����&�*�TEy��MM�
6Ul�"":�TED,`S�g�""����X��*"b�4f�E�lekl**U����T��"b��VDl��ڊ�Ml*"6U����T��"bS�T���lek0e��ߴ�rM'""L٦ڕ�`�jW��M�]�6�v�ؤڕn`��i��&����M���F6�T�&��`�4��El�8>S�`���	K���lR9>�7��	�pS9>�W�r�n*�F'�DD����'+�x�D�V�/�D�V�/�D�V�/�D�V�/�D�V\�i8l�����j�lREؔ4D��s:�*�E=_�E���(b|�El�/ܢ�M��[�	�p�"6�nQ�#��M*U�M"o�]|�'Uњ�.�𳪈M_�YU��/�����-��$ZqXD��9���1rT=\��M���!�T� �D.HK`��iid����6�vC,�M�xM`�ȡm	l� -�M"�%�I䂴6�\���&��2�$rAZF�$rAZ�D.H�/\t�lyd��N��� rYfޤMXӉv����.�?}�]D�»���w����_xP���E��<��t�w���
65��o"6�7�╾�&bSAޤ�%�ݧ3��5ex���)Û��pM�dk:���
�t"����D�@�`��ik:���*�$r��u���V�ߤ��C�n���lR��M]D�
6��qX�D�8��M�{��&�=k`�薼5�I��F65Q�7k�W�4�7�vC�$"b�T�!lR��N4�:ؤ��d���`�j7�#oR�t~�D��`�j7��M�lm����o��ȝ� y�'�?.�����×�?��Ѧ�~��Y��~߯}l]�;��}_�˽�mQ��.ҫ�Z~��?عˢ:~Xl��%�;���b��G����Ձ���_������?���>:�a������-��˓���R����������_��������,E���0��Ewpb��C51C��&_��CU�^�Y�&_�F7�h4Y��&_��������^�ꌆ���5٤���M"gr��E'E�.lQE���n�F��E5_"\�Dl�[Tg,҅-�3#�&Q��H���X�[Tg,҅-�3�®���.lQ��vUՉta��E��E�c��H5��7�T�� �ƗD�,չ��_Q�;��1��"'FDu��%P�;�r���*�@u��%��V���D{�.��%2٤R�T�\�A�K��T�\�At*��V�_�����E^�vy]�ƅ��W�I�:�N6�zչ���D�;��D��M�9.� ������6.� �o�'""�s���Ө2oR�+�$�o+�t�1���AT�&�:���Q�;���
6��չ�����"�_Du� r�ET��}DT�"�_Du� �����&Q.���A���l�1o�����=ZdOl�'G��E�w?�'U;k,������7|o'��I��&��5�Ў�.��5ڨq�En�������>k�S�xs�yHS���}nG�s4Ҡq�Uts�<h�8Gc��8'>zA�)c��>�%}��s՗�k�q^یw����4g�\�F�0Gq^g���1��) ���0�y��>�uF�0�y<U7������q>e�J6�yHS�ac��4e\��1��+��>%m��<g���~��s�1�S��1�y�9}5ƹ�9cw��Ԧ�1��O���^�hD�QSb0�q�!�q~v��\���w^�>����u�>C�X�ϙk��a��9%ĹM�U��\Q���c
��L�}RF.:%��S�nB��9�q�s��'� ��9�h���3�<M�K2��f엤<�y��'�1ΛM��|����9��)hL�?r�Ɣ�!�q�m�F�;��v`����X����r��mJ|�~ʺ��m����,�E�O���O��x#$���z,1��(���[�W?x���e��״���ޖ������}���]�?_������M���˭�?����ǟ/�~�'���K>��i�~H�6c��d�(�R9B9	���P9Cم��"T.P�B�
�.Tn�g���P��J�	�vòplW0,�vòplW2̄�dX*�aY��eeo�eYn���N����.�W��?ߤ�'��YƏ�{3dN~�Kk�4C��Y22m�L�L�%�!Sf�8d|�Ly�Y�f�T�&͒)�i��hͬN��4P��Bg��!�A�>+n:(�gQ���q�D�t�%S��Z
�iq�\ N��d&�M�IC ��I�C�̤��!Cf�|��#n&�i9�f�)0)́��$
� 
�Y0P ͢��iH�(`�@�E�ȡ�����Ƹ"��iX�'GZ:������Z�<�<���}�e�,ɟL؝�'�仵h�j��򇄯�ӱ�_.2'�䥁��7��,��®=+��P9A9�3��P�1�ˬ�\�ʁ\ѵI�L:)�;��9XŅ� V�P�N��2�u�ۥR���TʎxV�vyDeI�M@�Ԥ
�>K��2-̒��9�g�hk�A�Β��2���b��se�Qq���:����͌�=���G�aF�viG0|v\�e;��9b��k��'��Y&��f��ɶz�9%$3d2y�L�̬ws�� g�d��iC�1��,�2�$�&S�n�S27�fq�*�h�pZ#N�)��͒�uZ���hk�������8��Y�>�8�>�[=��r*;��P�@���|��J�A9
�;��Ny���مʆ6�P9��Y�L�)�3&ەS�g0̔c��U��������aB�40̄9I;2�%{d���=^�2E9�ʧC��PB���B�
�&TnP�B��S�#L�lhs*�Q9
���aQ�L�	�v�N��H3!I:&�1:f���L7�=�a:��_�u9�0�t���_X<*���X�O�ⲅ�_s�    �'+�D�!��y�D�D�!� gHtH�����A�͐8�zS<&����'q�`<��D]#�F����@4��]#�m�2�vQ�V��hD�(�w�G���=��/�Y3�"��5�A$׌�"�蝂H5� �'�(�T�FDr��A�*�^)k؛@$�)�H�w�@��!R���H	D�"%)jB&�HQ�l')�F/�Ep ���D�"e)jr�"%�2s$�;��Dj�w
"5����蝂HMC�"5{Dj�Y�A��	��&sp�#ir$��[��EA���S�>��rզ���H]� R���H]ӽD��[@���O��5�Cs����$���D�")k�_@��!R!�4ﴂHE�N+���\��Z
"+VmE��ʳ6+w�E!ó6�@��f� RѤ+�D�$fD*"5�lk��"%Q��HY�"��4�m R��2DJ"5��k��A���C�D'k�_��������g�N�ɾ��j�j�f�F��C�E��&R��j;��
T�ZD�}l��<~�j9Y�T�H����F���T�&U[�&�h"�T=6U%J�P����jf��&͜S,��1l��j2�bțTl2�I96��VU[����֊�ljQ��ț�J�����
6E%"�(��#�5�i�ț���1AU�ᘡ*�_�c�Q�W�I��D�I��`����&�)�M&bS�L4��d"6%��DlJ`��"'�M&ʛ�d"6%�)��
6e�*�t�є��$jk�N4�2��DYx��h��`S�tlʢ�.�MY4�e�)�f�6%U�MY�&���M6eQ;ؔElr�)���`S����$b��MI�&�N�&'�DY��l*�\��MY�ւs:U^���3-�W��өv
��U;�t���s:�A�9�j���MA��T�өv*ؤک�`���T�� bS���Ml
"6U�)��T�� bS���M�y�(^٤R�T��6�V�lR�$ؤZI6�I��l`�j%��&�J��M��d�T+�6��_;�$���W�������������������^T>�£�M��������5�d�&[��y�f4U�«&r*}�U�Vz/5�S7�pU����p�/\tbV��T�������k�/�i�J_��\��^D�J_��/Q�/"oH�/���F��"��T�~����wVD��d���`S�a��kP��M]D�6u�/]D��Ke������W�������Ey|�Et۫&�I�~�/�4�*��T=65��/M�&��K�	���Dl�/�4��/MĦ�:����&Q>_��Κ+|��%�wѩo�/�E>�
_��<z�pW����"L�/�E>�
_��|k�p�`*|�.rV��]䃩���j��p9+|�:Er��Dl�/�U;���ȹP�w�G��P��]u&	_��\�p��*|�.riT��]�Ҩ���ȥQ�w�K���"|�/|�\�FlR�^��"|�/�E^�
_���r�p�E��k:�*�t"6�H�p9�*|�.��Z�$z�����Ra�/�EU�*|�.�Y�wQ��
_��j|V��]Tϴ��*�|�.�?\�w�3�p������^x�/�E��+|�.��]�_g[�*�������lՕn����t���"�F̛Tm�D.�xN��D�/�E΅_����p9|�.��7��]�\h����\���"�B�/�E��_���M�pͯ͸��ɸ��	�p�Ej����U�X/\5�X/\�/�X/\5ӱ^�j�c�p�hb�p�LQ[N���^�j�c�pUf�z᪙���U�?녫f:�W�t����X/\���X/\�{�X/\��`�p�iCc�pU�z�"WUc�p���^��i�2��D9"|�.�}�X/\��l�.r�7�9>녫v�X/\��l�.���M]��l�.r|6���7���h�.rU5�W�6��T���7���.�T��wQ�F_��^x�/\T_��.�����i􅋪F5��E�}�ڭ��pQ��F_���M�/\TE���D��V�7��+}ᢊ���pQ��F_��bl�/\T1��.�|��o"/W�/��<?�*�5��g��U�j�{�"���Dn�_x9y|�M��l��7�����"J���D_�*r�����pE|�M�n�lq��p���n���~}��*{����/��/�7e�����g�/�t�j��rUY�U'd��w��>�:[�������"?S�����;|�]t�_|�1-?a�
 7���wyz {|R���{Dk��we�>�.�/;|�]����ywQV���w�ϻ�<<>�.Z{w����9ԍl�)��iNٮ[n�]#�Dܽ���sʤ���ǽ�It�����E+�������vj���}����ϭF�ŷ}Rٞ��L�і>I,ٞ�L�B�NRiP)�T:T&e�_�IeK����2��	k��	��T�6I��]E�L����t3�����T���{7SA��YQ�؟Ԗ������L���x3�L�����V��
cҌ����>cҌ��[���T�ۼ�f*����V*�؟�^��=���
��IL��|�+�Y=Ɯ�/>�s[f���Y#�BeR�×[E^�_nU��×[U�y��V��|�Ut���˭�����=�F��:�]&U�<�rOmU��
U�؃/��*����r�ܝ�?V�)[���T�F���U�Qf��(��J��hm�?���vQՎmU(���vQ5�^��X�G�E�@;|�]T+�7�9��m�
�leW�le��v���mݴ���vѭ�mݠւ�x�ȃ.=����(����Ot¢��o������/{�����z��\b�$�x��GH*~���0Wt��P�U�����E�[�i4Ԋ.ujE@;��+@��Z��NC���*UI��� /RqL"4�]U�H��0�i�,R`����"6i.�-R`����"6i��,R`��jW4�j
,,�g6YY~"^��?8��{KH������\~�?/����������g��>�--�Ȗ4W����R[�˧|E)�"?�M���qh�-v��mQ������7S��Q:v�5�f������yj�޴�ٗe�l�>�sO{""XD$Q��W.�iT�|�sQŮ���Ģ�PM��k��!�*N�4�Q�Lj��TJ��Pk�j��U��k� U�k�;U��k�v�U�Pk�j��/����h��Z�US}~Q�7IS�yQe=SQ��r�|�vQ�4�X�*x�o�.�؂�|�vQ���؄Z��-K�*��4�_T�e�1������Z˗M�٪���� ר�M��q�M�Fޤ���"oRm�;�&%y����\U���[F	x�U���[���ElR��tk�Ǳ��M"��rո�U�I�El��CU�I�El��j������T��$bS�N�&�Z��ܢ
6i\��*�$Z]�#^5�Ek:՜S�&UcM�:_����Zq�#���#�:�G��Nu�W�`��rW���#��zڢ
6m��T�ߴ�H9MlR�s��V�����?Q�^;뛊z��p���p���El�T�[T��(b��{��*ؤ�	���M�{I�*��iޫ�*�Dku�U|[kh�*\N���*.�o2Z�E+�U\��d���N�Vq�~��*.�o�0��h��y�h��L�~�٤�`���9R����7���)�����)r��������MDg���"�E��Dl�;\�4��E.H�;\�4��UYx��@��d���/5 ��e�Ņ�_�Y���,�����?~u�������Ac���w����ntO�
A�T����P��2�lP��B�'�)%��=�>�L)�-�&ܜ�#d{(}�6Iš2�Tc��B�'�)���ф��$@���Ч�]łW�'�^�C��Sî�+�P2�$y%^+!y2^+�F����H�q�l}vs$���w�V�@R�	�\]5��su�|�,[��Q��:1t՝�W�TG�2�+/�.N�Sͭ�f*�^����L_껎//PA��G�f*�^��_�Lի��t3|�j{G�f*��]m�J��d>    �LZB\��g�IK�ʤ1V�P��ŚE�Ŝ��,*���R)P��^*T&�~�&Ŝ�U-*X����V��M�9_[T8�O���؟4�W���/�,*p�j�;��"���Y�p�@�<2:{EP��������U� 58{��jp�V��X�Y� 58{��jp�V���*r���U��El9@��**fp�V��:�$r���U� 58{��jp�V����"���[5_�YT�7�6';o����y�\�7u�M��p�VQ������4U�i{�7Ml�nuOS�NC�go�<OSeޤ!b<�V�+�\�!bD�5z�R5�I��E�DwD#�?׭�h�*�$�@4V����&Q1�h`��s��&Q��h\ө�l�|�#�6i>O���M�\"�M���,��B�}��"��Yd�;�|���W~��9��}���sdd_uX���W�&�!�2��:�sd��:[}�l��[�#� �����Ȏ���}��9���L��ߙ'J����9���v;o�,(�ݻ�&��϶ݨ�'Jmw��ɂR�-�y�����a�,(�=\�'JUQv����:w�sdGH���y�#���n�<�Y����a{ks���ݪ& �~����ddU�?��M�y�Y��L�d#��RM@�Tj{�6O�ږ��&��a[�b�,R�m��y�H���R(m��-�d��SQ
��m[�g�,)�J�Q
ڮ�XvY�Rۺ&�d��{�m�g�V.�TpD9�W^�x�,(�=ś'J����sdA��x�,(�=��'J���sdA���%x�,r���F�,)���{���*�#J]w����u�n!J]W�����un!J]W�`�Mu��������×_�������t��Oh]Wa�S�a��F��@��V��<��������<G@{�����h���d��ݔy� ��"�<Y �u���,��b5O���'�'�-,�d�mo
ΒM�i�h$�@J�R��y���'J����sdA��]��,(����ϑ�^w��9����<G�z]y��ȂR���Y��_Y@�9���RQʘK�Z��@��M�=l��Γ�q����`F*�O�=�L?	v��2�$�у���`H*�O�#=�L?	���2P�J��	&��2b&�ԃjY��R�eu�K=���	.��ZV'�ԃjY��R�eu�K=���	.� [V'�R*J��TG�	.�.�n^�I=��0&x���Tn�j��f�<��T���zP9~�A��Ip���'��T���I(�"���В`Q��?Z�U�����J�u��D���a�C]u�0ѡ��c��PW�1Lt���&:�UZ�Ae�Lt�Wٻ�bO�It���7�u��&���v޼Z���j�jYP�joͫeA���f�,(UU_a*%�dRJ5�ѡ�2a&8�CUQ
�PU��C=T��PUE)8�CSP��Rp���s�ɂR�o�Γ��S��z�^���X@JfYj���JaP2�Af�A=�L<0���� 3�4�R�y� 3��sd&���*��:�KC�s���\�Au�0�uTw\�Au�0�uTw\�Au�0�uTwS�OE�NJ����yP]R�p����y}�=�t��ۺ�TGF�m��i�UM���y�)��Z1�4ű3��q[�h�j���l��6��s��yܮ/���M*Մ�j�+2��q[�m�*ش�M4Mlږ&��
sԶ2�4U��6�i��U�u)�R��<mMJ�T��x��ܶ'M�T��m��i�`�h7G�I�a�wy}(�\E<��Gч\3��q{�>K��(�xb��<nOߧ�"oU�ȉy�h'�I4��T����i�`�֕4Mlڞ�OS�����T�����,Ux����}�*�t"6�Q�G��T�&Q����$b��Q���M�D�E˙k:�%}�9�K�D��ΰ�'�g�3��I�	�#y}�=�G�D��ϰ����i�țD�0����i�`����4U�I���y}�=�@�D����'�G�2��I�A��x}<1�<�D����'�G1sa�$b��i{�|�*�$�pz.��V�+\�ke*�*ش��8Ml�^r��
6m�8NS��W���M���T�&�&�DsN�^�(r�O��H�T�����i�`Ӷ��4U�i[Im�*ش-�6M�k:��_KQiT����p��m�i�ț��g��#U'+��ǭE|�*<*�˒��7��G����r��U��ã�}oxT�oX�\�Z�@6�TQ�W�t��E�f�/<�V�N_�h���V�N_�h���V�N_�h���V�N_�([s��E���"7��n"���n"��?�����p�o�X�@4��n"���n"���n"��G�M�1L_�����.��s��M���6�n�9|�&���������n�[|���	�p���D6�����&��7�����v�£���|0N_����|0N_����|0N_����|0N_������w��E.H�/<�>����G�Wu���"6�]�&�����4U��El�/<n��LS��Uw�����v�V�1<n�Mk,�$���(I�1<��7cx�o��(��8��Qd�qã�~�0��(��`�"���E�/\ԩ"l]���E��M0�G�5>�1<���9��Qt��a��k|cx]�sã��W.�Dl�̛Dix��@�ʼI�:�)��ó� ���U�ó�~cx�qó�����E���,��:��Y��cx]qó�cxVm���UN0�g����Y��cxVm���U�0�g�f8��Ye��d�h�cx��
��YdH,0�g�ը��E����,��ó�.W`�"k`�1<�l���,�|�@6�T�&���Yt����^�ר�M��g��,ڗ(0�gQi�b\өF�$�xU`Ϣ����,:	-F6��
cx�óhG���E�H��,:1+0�g��`�`��$���E����$Z5�H6��W��vx�%���Eǃ%N"�'n������I4��Ϣ����,��Z�Ϣ����,��Z��"/o�3<��F%�M�x�3<�<���,�8ó�{_�Ϣ{��,�SQ�Ϣ�#��,�+S�Ϣ{A%�M�x�3<��\��,��8ó�S��"�O�3<�N��,2sóȸV`�"�^�1<��Ź�$jk!�Dk:V�VW^��e���1cxW���E��K��@�K��E�
+��*LVW�0+����&Q�Ċ�z���i�b��M�lR���ф����"oU)4�����Ea
��z���Eժ
+����]T��b�콒M��2oR�W�I4�a�*��\��"b'�Dc��p�W���Id[.0�'����A�.�[`O��m��$��UaO��^��$2$VÓ�W�1<��T٤R�DWQk��I�RaO��^��$��UaO��^��&ͪ��.�"G�1<��TT�N�
6���1���cx��+��It}��&�h�1<�f:�E_Щ4����Si�q�ȼI�V�I�^�7�.#U�E`���#K��Ӭ^Ϊ��o�ڡ�Փ/�A��TmT=�&�jD[�H5A��T3z8�Tm�"Ղ��H���I�J6�"lrQ[3�$z�lr��`���6��Mlr�3�TUcxd���'U��E�z�\��d�M���ޫ(^}d��K+�Uќ�`��F��M��:zX5������
UѬ��*JtPB4��I4����FSA�TE�S�*�p�P���MM�k�&�ׂ���������(����(Q����̴r�IĦ�����ʼI���)�F�tQ�V�)�F�E3]��h��`S�tl�����MQ4�5�M&��F6�f�6%U�M&��6�(^�d�x�L�`��FSǚ��f��5�j/��MAD�6U[�&S��MI�
6�*r���j+ؔUclʚY��MYæ�7eM�ؔ5�z`S���-�MY3���5�&rZ ���M-pM�aS`SR�0ؔDl2�)��d`S����$b��MI�&�N�&cޤYq4cޤReޤR�9��M�s:Q��"�t�l-bM���"��U�Z�9�*[�8�Sek�t�l-�C��D��@�#F    �I���n*��n�l�pSek���*[�/�T�|����7U�_���5��Mt���7���%�M���n"|�/�|U�ʽp�{�/<l���#q�r�$>���~y��������_=�)�*������4��E��|�&���7ѝ������5��E��>q�ݤF���|��'n�[B>q�:h���4�\��n�4��E��}��u�>q�]�F���)��7ѝ�F��*{�O\��j�|�>q�j�������7����'n"oW�O�Dޮ����]�>q�)p%�D�|�&r�6��-������� b|�Dl�O܂�M��[��>� ��ƻ�"6�'n]�&��M� m����nR�O�D7gZ㹝��`���L�O�D7g}⢛3�>q�͙�y�NDD��MtG�u�ع�S��M�;��sM�z�`S�	>q��������[�O�D��:|�a���u����M'{����;=��)�NO��+��������w�̓ho��g�D��>�$���3O�:$>�$�C��3O�:$>�$گ��'Q.��3O�l��g�DU2��M*U�IT���g�D�>�$:���'�iE��<�N+:|�ItZ�#�$�%��'�iE��<��o;|�ItZ��3O�S��yR���'�ǯ�g�D��yy�:|�I����'�ǯ�g�Dޒ�yy�:|�I��y��f�I����NR;|�IT_��g�Dh;|�ITm��W�D��;|�IT���W�D5~;|�IT�g�I�K8��Dl��<�<����S���g�����`^%�,�����Q���������=��=E�S�NO��y����=lO3eO��M����vj;���pθ]�˞�ܮ�eOVnW��� +�� �� +���� +������>lwdOax���S���\J�`��#{
�s{L�`続��)x� Z3W�5�2�J6��?�N37|�a{�V�`㶒��)�F�i��=���,{
�ԜǕ5����ZJ�O��/b�6?YU�I|U}��B��A�݇t�]f��	������<���E��k�����cY#_�V/�=��m�-�S���:
�� ���+TO��a[�Q�`�R��)��m�F�Sp���q"l+;ʞ�^�I�G�m�
Y����2�S���ʋ�:�/�"n�jz|��S�2�iޯ�%kY�y�b��e����]��Ey䶊��)�v�-F����9Z��B�	�"�<q{�V����meO6no�ʞl��ƕ=�=�ڠ�*��55�U䁚���*Y'qv.�`��F�5��lL#��8�<D�o�4�F�Q���o%�9�߂��*<D�3����5��Ӹ�5ueU|�D�����Qs��C�U9��5�^��5�o=�>G�8z=�>G�8z=�>G�8z=�>G�8z=�>G�8z=�>G�8z=$�ElJd�(��\#�7��Qs����;".�~��"�����\����o�y���7�<�~��bx�C�1�ߡ������|C��w����q�#i�x��;�u�em'�D��w$M%=_]E������޼�Ӹ��4�<8k!�8��IS���_l�LS�4��<�E�T��P�&�q�"�u�R�׾�Sp�}��ܧH�/�ɞl���)�^��O���]p�"����i�U~eݸ�2iܧH�/�x������y�b�S��z)���)��>�,UܟH���-�`��˧�*ר�̺q?M�Y��C�|mQ%�D�uc���.7 �,�,}�CX�[�R<D[�����/������ۥSV�3#�.--�;¯o�r��U�$�J���r�[y�JU+��X%C��aw�Y�MѨ��S4ڨ�X��v�v�#ަh0J�y�Yvqf�[rM,>�%	�P��������)o="������sV��'/PI�MlΜe	qbs�,Kx�6gβ��dΜe���5��%*�O���KT8���Q^�R������7������5����u+:׼��w��\~s��G��/����?��ęo�ߕ��u�ݾ�my�fLܠ}��1x��}�2҄��O��˵��:YTO�Ϋ�t�UP<�3?�&��1�����յS�w�,}N�~V-_|~���O>��_����}�?n�(�O;��M-o���|,����j����ϐ�jy�����Z�B���I=9v@���o�����@=Sc��z��N�L���;�35v�gj�4P���F��:�k������~\=����:��x렫��x]�z�u�5�[�k��W/�]�zj�kT�t�ry�5��t��w����iM
�^�5)�z.o=����I9e�5)�zY��J�s���b� 깘z)p�PM=���x9�ԋj������z��g��xߪ~9�ZԿ)�pVu���Έ����nY��U�v�4U��]s���]}�VG���ah��>��:U�H��NZ�-b?�w�؟��S9����ϐw��C>���Z�B>���M-�!���'�у|W��(:Wʃz&�|P��q�@=SC7�z��N��|蝩wʧ�\�3�|�@=�N��XSd�6M��Ɨ\��m��j�g�U.����=gȫ��W���@^=�dе����S[�W��zUxN��!��{��z�qP����^Uc�A��N�ԫj�8�'<P���_@��l�[�_�[W�e�=.��h�Y����J�jS�@*��,=���h�A�+�)Z N�;W�ر��Ov�*�ݛ����|�x����
��-�G�&�4hV�f5O��5�Y$���v:4�D�@3J4+4�D�Mp�%��JMp(K���,�ʚ����	��5p(K���,�?8%�I��D��C&ɇ:8�u�Cup�%���K8��!��Lӷ�P�p��CA+�PP�J�PP������������s ��b��
�X�

� Ŝ�8d��J̇4���I8d�P��!�L�!�L�!�L�!�L�!�L���"O�EM|�C�<���(��HI�3�CQ������$V�CY�'D55�˨�5�BS3n45�CS��� MɸM6hZ��)��,&�M�����"aB��d�L�P�p(�CE¡Di�'8�Y;�1�&��l�?%L���f���!�z%�C�s���!ɜ��!͚7�C���4{���ϑi��ҬW��1:8�5}KI�����i�x/�?5�R�)a�7hJr�Д0�0���bД���)�MJB|J�W24%�/䐄�ҬW
8�%���4�`��C�vV�C�W�C�X�ȇ4L�ȇ4�ȇ4��X�i�JI��u�&7�䐦o�!M���!�\���&���Q�7ޘI8��!͙k#�$Lh���5s�4���C�{��C����C����C���#��w����C����C����C����Ý;8$��;8$��;8$�����s� E�:�Ԯ�O���*8��2M߂CU��������n�p�j�-9����!��!�\2���+�l7�C�8$�+�I�'��CMpHr����	I|��!���#�C�=��cP�kz��Q�Np�J��|H���O]%�	��U�'�O]%죟Z���O$c~jM�%O�F��r��%���~jI�!��ZR��駖�<r��%w���O}����grH�>��'&h4�.��	w��%wߝ~j���ZR��駖��v��%�=��^Է�1J��㞫���{�ߛ;��5�s�SK�`�o/�9�Ԛ��?�����O�����Sk�:�����O�Y��O��5�����~j����Zr��駖�%q��%�˜~j��O��Zr��9$��Q��$�˼�C��E}j��/sԧ6I���f���ԦY�O�Y�>�į��SK�:�Sk�:X�Zs���Ԛ3��!I�s��Z�w֧��0X�Z�c}jIg}jIg}jIg}jIg}jIg}�"�WX�ZR��Y�Zr��Y�Z��c}jɽ+g}jɽHg}jɽ+g}jɽ+g}j��YX�ZRS�pH�-�SK�<e�V�>��oRX�Z�)�O-�֧���
�SK�J֧�x�aH�F*�Om�;3Ű?$��
�S�$�-�Om��CA}j���
�S�$�-�Om�=���Ԧ�P�    �$� J$�$��!I|�>�I��ԧ6�}��!���!ɞT�����["�Ix�!��!�C��}I���NIX�I��%1�0>�C�uYb>$�P�4k�DI�iւ�ҼOrH�[֧��d�C�Z�%�C�m����^G����^G����^G����^G��P��-8$�p��%����&�sZ�6�=��䐦o�!ɽ��̇$���Ԓ�k~j�|���>��Za}j�7%
�ԒZ]�~jI=�B?���SX�ZR���O-�V觖Ԙ+�SKj���%5�Ԓڈ�~jI��B?��z��ZR��O-�XV?u?<ݭ��{W�c|b����滷�g��M�l:Z�%��M%됭*�2���ي��l��l$w�f���d�J� U�������EːU��9dUq�
dUpl���dA)���R%��Ȫ:��RY��\J5�N��f��:�����Z��.:(e� "�TL�ȥL4Հ\�D�P�Dq[r)�mX�h�+�(�k �TL�+>�j �\�nA)��P�UC�@�,���1�%��F��ɪ��@�,��\4�V#�Tqk��*n�"�����R�|E��e��2W����+|���Ͽ�����?�Z�~�� KY��,%�"�����%^S��Q�@�܈Rj�F�l$c#��Fr��j���� b�
��ZUb�#Y��J��L�j*J%P��(��<��'WQ*q���T"�T9[�c�V���s��>1/ձQ��|�N��ӡ�R���c�:���`{��C���z�NA�M[���<�/����i��:���~s�>=q�T<��x��A��G�!�Jwd�3���ө�K{��"{}�sU���>N���G��+�,/����b��U��+L2/�K����T��ŴQ_�[\�|�θN)W�J�����T�͢��0՘NH5��z�N���y���R�J<�Ӂ�F���r)��8�KQe8p.��
��E���r�����\d��p.ǨRp.W� ù\�L��R��p.���"3���\dF��sl��\.2#��2#��W��H��kù\��缑,(uŶ�dA�+�On$J]�)z#YPꊳ�ɂRE5��\��A��,(UD��H)����\^�ʊd�K�(��\.ED���Q���D�jp.G�����\�8ع��H)W���ˮ�58�]�p.�,n�\vY�¹첸�s�U����&>8�]��48�]�iJ���4�]uE����;oFfW�yk02���[���U�-�R2YRJ5����*ko���U^�#����-2�R)�]e�m02����`dv�BFfW�7�]uٻ%RJ5����]���K�(#��v�Z�d��J�v�Z&�T�A)U-��GJeU鶖3dU��*\�Ys��*s̠���V�\��A)U1��w+�%�TS�ٮ*��`�vU��ȥT��#�Rյl0n���gsRJ5��H�,[hZ[�/��

�~�:u?�*nr)Y�
Kx���s)�T�K�vjJCkUIM!�T_�UPE.%;�D��*�*W|*&W��T����U���Y��ʪ�I�Z\���֢HT1�U��*�`��b2�fG��=���Exϫl��Tp����ַ���d�̫�2\�RI5�;K���-��U�S�y��K�{��*�����\&�W����*�؅���2Gxϫ����ک��W��_̥D��{^U6�Ϊ٪˒=Љ {���h5��R�֒R2YPJuD��=�*3i7�R2Y�R���yQ�'wxϋj_��{^dqk,�"{���� �Y5[����=/�M��yQmuvxϋ�@��{^T����r�tz�U��N��A�#r)����{�r�ux�S�u2)%Z�vz�e�m�O�DJ���:��E���\J����&>z�u�EM��=/���"c2��*�G����lѝ�s�,)%�dRJ5�eRJ&�\J5��z���1.)r��q���ʃ��ׇ_��fQ��ǟ�wf��O��X����×_�������t�j�g�TiӪ��%Q9�gmNKv�p[�~Z���0�������N^q��mB��+n��TUi�(f�RT���V�KuX�zV���Q���e�KuP��
��KuP����җ����/�Y�(C{���:����/�fU�^t��+N�^��O���EO�)�C�.���q�)+��q�����端�����<��w@������D�Q���迲���O޼�����U����mۇ��(��um{�JEE�Q2ۤ�u4l��!i(����,�ኣ���E��M���s�8/�Z���X�5j$C
>Od����;����~���W��~���o�8������_T?ءulg|*Q��<r�+�3/�WTSz�NBz�6l�H�0�)�Ӓ���0��4��I��Eǡ3-i��`Z+�3o4�gbG{��O
hϤEԢCL{?	8��}���>����>)���>���Ӳ˄M�+��/�a�0�o��eR_���p^q���:Xe\�{�7t����4��3�W��_���v�]��:����/���3�s����+��/�IXe�V�g��B[�WxG_ڛˬ��˨����8��R���I�"��%�{�P���7'	5MlQG׵iBk�A��2�yBB>O(Ahި[�xBq��cxO"�<!��&��M�#��͋�
2�y]WA�2o0T��X-y��`��`�d��P�A��u�;��wD2���P�BG�ǌ��f�?�r�+��%���v�w��&/>
EqH|�e���C��s��� I� �I��߬���oo`�B�`�c�[�5����~܇Z��Hx�n��+���
u]��
uf%�	!;�h|�i��ߣ��Ğ��^�B�d����SJy:�o}�	��	���Ԁz��=����R^���L(�w]�Y)���[��7x��G�Hdd�J����F�N&Ç���A�T�q��&�vr$��Ċtڶ�V�%}�O�����j���*k��d�cV-�-��ELe�,bF,���
Y`��)��Ȫ��dUCʈ%Ր�Y�-c�S�ds�V�N�1y���ֺJ�j�wJ5�"(�T�6�RME�Ju�"(�U����h`��*JERJ��JuYܒR�wۇe@�"n_�HaԹb�y��aY�4^�ў�G�Ku�L������2��:��6o��=�4�_���WQ�"5��i�����yY�����F���I�i�$G�L{]9aXL�y-l-2hqE��R�"��
���"/��~�jɓ;dU0t���<��bՒ��%O4ՒǑ�����K�u�M�!���#XR��^0FTk���y��i|��a1M�p�2m�P�wش|� ︂/�A�q�^�Ku��4m�P.�G}]��*�-e��-&
�0�l�4�V&�!�Br�U��V��j$�Y�nVM�U���YUJVI)UZA)W�۵BV�
J��Ru�T�l4P*�:��RU��Je.(�e��d{y�ʪ���R�i��RW,,o$KJ�:�TVM��RM|�r�;(�*JuP�U��̥dRᢏ��������#���ɽCV�dE�mYQ��!+�cH�19�Y���2YRJ�n+dE�Tȥ��R1 ��*Jr�����R��&(����6R*�:���Z@4�RU�nA)U��R�4��\JGC.�ڴ����N���j�>FRJ���\J�i#r)զ}�ȥT��1�R�M�I)U
wq5���N�TW����|n�L� �z��YV5\�gY�/铬l��p�UuD���s���
�	���Vr#Y���*n3(�Tq��K�.��<�RAu1-fRJ�KeRJ5�3o۫�ՙ��USA�_J��gPJ��gPJ��;s)U�:r)Yz�X�JD�d��NJ�f �T�OљK�(堔���A)��R�좌�RA��,YU��R��ѱ`�\UI!��NVQ
�󠪀�=��23�T�V�8�ST����1VRJ5�*)��o�=��Tz�U�c�TEu"��AU0VRJ�xϣl*��<���� ��<���=�2&7�R�w�y�M�UűH�y�����*\�{���J=u cg�]ʼ������q����_/�G���ez�Z��_�%�x�����t�7�    O
y�/��������)Fp,=pe1��w�EI�����x�t���Ȗ�!EM�_�����/c�e7��ɖ��T'*%(��JyT:�')��T�mz��RzB�=_I'��E)כ)��]��~��n�o���P�]}C�d�}P*���ݛ��8`y�8p��$%p�TEc�8p�&7I	�J���.;I	�(3#�(#7�eb�F0���J`D�ȈF��)��*�����&�'2;�]���fvp�V���ȯ3�."?M|�	���zB���6!�}b�'D�O�f|�\���<q�'p M����&��	�H��DFL�ȷSZTHc5�
i"�2�0q\gP!�n\�����{�D�dp�f�p�''��v�i�m�`�pf���@��X��&��|�v1�����b<����#�ο]o~򒼌���)d�({�9P�6�6�l�lɖ ٢�5ȪFr���*�YU �٨��Ns�B��R�m��,nA�&�[P*�Z[A����z��3U UP�t���j���TU�m��l$�RU�������RU��TUͷ��*\4�RU5�6RJ�ZP��ZJ5U �3��K�1�RM�J����RQ�Z�R����RQ5uP*���JE�T�A���c��
���%�� �������e.%��֊p�C��K4�s0�VD�"dE��!AVD�2de���!� ʡ`$�(�C���R94Ȋ��9tȪ(e��(=��})�,BVE)C.�Uqk��j$�%�J�֞;�S{��p�[n�l�(�h��
�2E�Açh,d��{f�a��,^�,-�� �&Y8��˿����.�z��Mm�	�墶�}�
�O����g����j�7$�$ބ�<8C"B"ϐH�(3$�*��˻Xg�E�(�$~�:	?I�Zq<��D�D�!Q!a3$�E��&
���(�9���_�O?��߬M�����?���w�|��{��-|��cs~��o��dm�L^w����[�p>�p����������b��d�S��.|ZKm����3wo�i��������7�Ъ����럝�n�}y�w+�9������R+�Jo⍕�Y��C�.J-����JJuP���J���TÍ�l]~��Z����w�o�����n��x�H%K�1\�[�!���6ܾ-�)����w"��ÿ?�j��_/�������?,����Ͽ�(i|�%�Nx�?�����(�����Q�]8}����c����W����<>�����X9�	��X	���?Jey]���c%����fq}A��e�\�O����V�1\��px�ܶOS���OㆧI�O�~�S�4�eO�f���x���4��O�!�OS���=�&�i����O����f}����ǔG�f�.OSv�)������٣oS�7�A�4�<n�U�1��޵��'����񀧉���0n.3��i����0O�G<M~|�=X�	O�O��}��4ex�=���Oc*�=����C��1O����4��O�Q����f�7U0���(;�~^O�����7O�H����Fx�f����5�L��i�`qE�[x�M��MUD����_E�ې��WD��Mܣo�6D��{�"��}g��ix�af��}��"�y�C�4�����a�`C~�G��������*�Ӏ�1��}�!K�t����03�=�,���P�x�8+ߺǛ����cu׸�V�y�7���X���}ә�O��N[	\��aW@��Jhؽ~���;�ť���e�==ͧo��Ú�{���_~�/-�㒡ߥޤ�?�o�#��(� r�w�>K�1|����E�W�-�\�x���.4cf�,	��0I�0mx�u�\��%j��ǇY^��aһ,�%�{�<<���T�0=�a��5�&~Mq%�0����a �w➉�6��0��0����a�om���wf�!+�e{�ik�����7�5��+���$z,�c�5�el鱪�@����2��6t�ɳ,�x���.��ؽI#��qM�.�>�j�'��kD3D�F���%�D�{����~��{;D%�w��Qҽ�wDFQ�@Z?)2�J����c�J0�~�b��$�_�s1����Jr�����d_?�1�J��~c���S��4�����QTC$+�^�(�����M���c�7��I3���i�4r-�!R�;5�Ԗ*BF�Nߩ&sH|����q�!R6�j؛#D5)'�jr��ͫ HQ�2gM��
Q�3�$�^)(�)��	�}K����2񬷃V����tQ	/�==��������ZbUϣ���e�n�^Ï,�{��8�x9��\�9�{Ӟ���	����	:� ɟ`���	���ӱ���	�<�=�}_ClT�B�
�&TnP�B�>*+݉�-��U�f3(߳�1���,fd����y�' �m�� �Te�5�=��v�m�� <A��	OPwx��'(;<Y��"HvȲ"rݠ�u-<H��x}|�=�1qűC,$P9�0'��[H�[�� ��	�#1�`�q�#�`�y!'<�ј3�`�� ��%�#�2�A�a^�O�G4i�q@&�&�<pd�q�q��Tm�> �y���u�>p������{d�&���� L�;0���;���<�w���D�!
b�w`bA,�v�
ca��"�#�rʹüPe�X���D����BE~Pv�*�L;���u�\���e&V0����L�a40��L�;P���u*7��v�r#w����x�w`bc��C���ľCt0��0;��v`bg��;��v R���sc�o�Lܣ�ĶC���Ķ;���L\�����1���U[`�>����qw?�����{�D0qH`������81��;x0b w�fFwp�E�yc��	�D}�y��h�wp�Fw�L��h`��@��q�> wp�F����H���@$��m�>@�w�AD�w�F���J�͸=�^ݸC~��M{D#nP�� ��i�ucb��C���Ĵ���;��	LL;01��i&&01����<q�> �<@���8���=f&�_��K���=f&�_��ng���=f&�_�=f&�_�#O���=f&�_؃��������{��9��G��`���_�㌅��8c��_؁����G���{����wy"�/챗��{�'���w�"�/�Pa)0q�ݼ&WxƢ�}�[���	B8�7/1�p�?��Z[�&�C���f�lU�v�&�욄=�&U'����ZW�&�F�l���d�Y%��M�w[!+k-pU�p�⸙��-��1?���m�l��*n(UT@����
(Uq[H)U�RJ��T��-(�Uq[GJYV��:R�dSA%�TIM�L�Z�R��\A)��dP�T3P�L6�@)S�@�2�ԘK��^���dA����)%��LE��\JE�JE�(U�j\�(�H)ͪ����E��f��o���/3�Y6�J��ﯲ����VJd�({Jj�}�䦑�K���_���b?�޽��M����k)��o�[���?·����c�q���_,+���n�N�YQ����/��f����������v�����|��w?�7�p����.�U�}X�������u}�u۸,]v�w�<������R�������᷇�_.�P�GX2��GX?A�y��^!�����#S=B���G���,y�e!:���kq�#�c��;�#D����z��G��GHoT� 4�M�SMDX��3|��,=p�x�ÛE�²HXg�b'K��}\~}z��t����s������7(��u���w���R������{i�������Zm��	K��47�ǈ�s���eby���7�,s��b������o��7��Elu�����?�{y����{��B�Aj齼Nb����z����f��G���.J����J����r��(�nN�%,B�q</-��*U�@=p.�1`CQ��܈S��P�,�EVI�<q�̏mŽ�Ԥ$vtRi�<7����_�ߍ�Jy�36"" �F���ck�I�$�N�j-[��e�.ng���8��qe�Hp �Wנ���5hM���B�09 �   M�*�j:O{Nk� ��4��������h���vC[�,��M����}޽�c�ڽůx��;��m�>�������ѳ����� �g�p:��:{֜YF&0��'��N���D�k4gJi!�Œ��^Z@?�A��1��q
�����l�Ƙ�Y6f:�&kG��%K)�S���ɫ(�,C�Hy��9���D�着���      �     x��VKnG\sN�����9D���(F` 1�l�$1cBN�aǉs�)C���}��$U�ސT��ޢ@�Lw�OU���Y'��8q�4�U�Ⳍ����U*�	�/�C��%nK��i��8b�g<�y�T�>���
'�&�;�+5]�"`C`c7q٥�w\N#���ܲ��:6�H�0�c��=�4<��,.�T��n�4]+�<���>�XX�/��g��\k�zK��+b��e�#��sŞE��K�UTظ"�����ƳF6�1��?(���yXn���+�_�������`�� x�F�DK/n�0'�%𭰲�٥��6&���ᕒ�"��  ����y������Ҙr�.�d�-�~�}�=���O����:}���l�!<�S23%��!!�%��!�� �R1�����$�G��9�	�H,N!|��8 �0�>��;�"���f���%���9�Qn{}C`�k�/��s�`�f'�k���P��&�'�S�<b`f�����@������~f%��݆)d�0/q�HK}�.U��KCRY2&�7��!�����P��. �͔~� z�mВb�]��X�321H�(e��l�(IUe��YP�m���T��`Ց pQ���Gc07�ťeJ��}�P��_	��v�QW�����-$��ީ[���W��@��.K3 ��!+��7��v�J4v�"$qGG
��8e�}&o�v"�q�:.2<�Y�Ȇ5Ap�u��/V����Bl�fK�݀��q�>Zz�_{0WY�\�L��W�ͭ�e��Lf�QAJ|m��^��L�+I
7lO־YR��,vv �D+4`%�p����3Y}.�5x
k��]��x�[��n��К�TP���=���N΢�.���!�*���"am2�n@_"Oz����$蓂�G�*|�RD�[kE�&o>�8Gu���"#��(.���nDz��m�76�vj�~��o �t����������X���W
�9[_������[��_F��S���r���;��Lq1��l
N���d�L_�7m��(]���h��g���\[U^�6������,����4�~��T9�J����*�o����*=���%+�$�!)j�-����	禹}�ݪT��Q�����}��}l���\����Iw���"��e��nZ�(,�̶́��G>ోÖ���Pnx�5r�e�Z�l�}��lE�_����E�%_h�=9����eϟu�>���^����٫���?;9�����ɾ:�@�̋�Q�y�);�fY����
      �     x�m�K�$G�����TH�W.�����7��0s��4M��լ�1��+��Ȓ""K�)�E��#����G���q�c}� ��/����}�/�tY_B|����C�&������P<z}����
܎����EY<E��xr� ��z��/���~�{���8�Xν�V���p�EW��� �~\z�`׎�F�1zX�Ap%��xRH��ú!�n8f������Ѯ�Ƴ�E4�v����PW8�Jx��@t��%9���r�HI��/����hRCs�nY�$����eg��%t�@���r{rv1�*G��FL[���0I�R�צ�sHˎ?��������G���L�;Y�((�#WZ,S�U�q����q~fF����S��P����(���_�I.����d_�a/œ���ruk�$n�'�C�.�
��n��Ҭ����-���eO�܊�խ���i>�_��.;�}�Z�tl�3�����l��}����g����Y`��P]^7��=_Խ9T�/g���P}�s����K�a�Th���V�/��ʷ_X���<s�h�KX�	��R'䭘xk3���y����x��a�y��,B�!h		!!�&��q����\��ٲ�Ί��*gk�R�&a�G$Ml�D�hH�� ,�� -�B�q�d�:gC�:k�	�"5B�Q��ZM��X"��\,�\-�\�,gL��s6Ds��	���V�ٳ�<��<y��|N�`��C�������{��RQl�KA��<8L�!r�۠�YR�%����)/$3y���K0�(�$h�FNDc��\ֿ�Ђ��
���ǖzT料3A�b���K�G%M�� <����fԜ�iy�����q�q�\gL=�$���%θ�/0�>�g�{L3.2Q�;%��VYɎ8�+�$
�g��k�������Qŭ�:�L�ǵ�]x�*Y(C\�%r�Լ'��LF�]M�7�I�.��w�'f����o�����&�}ot�܂�6H�1�p�X�P6�f�ض��T��'�W���~B�a@�      �   {  x��TMw�@]�ѣ ��E ��D<=���0Ç"*��l���"�.r���u�Mc��y������7]�v#3ݥ]���H�I"��\}�~T����y����WO�������0^��A:R�Q���@���@�ԜJ�y�&o4@zx�� h�/���uw`h�%5���n�'�Ԟ�� x��s$a� ڢ�!��A �-N#N�p�i�C_��(���.�TےƱa�d^!�\zPT��?\����}JŎ���6L��ߢ�U���$j����������V1�ɡ�-<.:J��X'�~��/zt�Ջ�T���^�����
���?ci`��U����]��e�*�x$�Y>�1�p�l����\�I�>���.�i�|��UOט6��~e��k��x{�7���Mi�O�gH��H�r�~������R��H�Y����8���Z.O	|������z p����F�˴ "�K��(kN��B=^������L��\pn�@���Fd�[�.yUa<�¹	�>�y����<�)�n9˚����J2o�R�cg�%�e�<��8M�?���~Kh���1r}2�F>u�^�	����h���<_;BX����F�6F�e��lc�ꛛ��*a?�Y���k�D     