PGDMP     *                     {            t-base    15.3    15.3 &    9           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            :           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ;           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            <           1262    16399    t-base    DATABASE     |   CREATE DATABASE "t-base" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
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
    sns."takenOrder"
   FROM (((public.sns
     LEFT JOIN public."dModels" ON (("dModels"."dModelsId" = sns.dmodel)))
     LEFT JOIN public."tModels" ON (("tModels"."tModelsId" = sns.tmodel)))
     LEFT JOIN public."condNames" ON (("condNames"."condNamesId" = sns.condition)));
    DROP VIEW public."cleanSns";
       public          postgres    false    221    219    219    219    219    219    219    217    217    219    219    221    220    220    219    219    219    219    219    219    219    219    219            �            1259    16418    sns_snsId_seq    SEQUENCE     x   CREATE SEQUENCE public."sns_snsId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public."sns_snsId_seq";
       public          postgres    false    219            =           0    0    sns_snsId_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public."sns_snsId_seq" OWNED BY public.sns."snsId";
          public          postgres    false    218            �            1259    16409    tModels_tModelsId_seq    SEQUENCE     �   CREATE SEQUENCE public."tModels_tModelsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."tModels_tModelsId_seq";
       public          postgres    false    217            >           0    0    tModels_tModelsId_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."tModels_tModelsId_seq" OWNED BY public."tModels"."tModelsId";
          public          postgres    false    216            �            1259    16401    users    TABLE     )  CREATE TABLE public.users (
    userid integer NOT NULL,
    login character varying(45) NOT NULL,
    pass character varying(45) NOT NULL,
    email character varying(45) NOT NULL,
    name character varying(45) NOT NULL,
    access integer NOT NULL,
    token character varying(255) NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16400    users_userid_seq    SEQUENCE     �   CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.users_userid_seq;
       public          postgres    false    215            ?           0    0    users_userid_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;
          public          postgres    false    214            }           2604    16422 	   sns snsId    DEFAULT     j   ALTER TABLE ONLY public.sns ALTER COLUMN "snsId" SET DEFAULT nextval('public."sns_snsId_seq"'::regclass);
 :   ALTER TABLE public.sns ALTER COLUMN "snsId" DROP DEFAULT;
       public          postgres    false    218    219    219            |           2604    16413    tModels tModelsId    DEFAULT     |   ALTER TABLE ONLY public."tModels" ALTER COLUMN "tModelsId" SET DEFAULT nextval('public."tModels_tModelsId_seq"'::regclass);
 D   ALTER TABLE public."tModels" ALTER COLUMN "tModelsId" DROP DEFAULT;
       public          postgres    false    217    216    217            {           2604    16404    users userid    DEFAULT     l   ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);
 ;   ALTER TABLE public.users ALTER COLUMN userid DROP DEFAULT;
       public          postgres    false    214    215    215            6          0    16464 	   condNames 
   TABLE DATA           @   COPY public."condNames" ("condNamesId", "condName") FROM stdin;
    public          postgres    false    221   m/       5          0    16457    dModels 
   TABLE DATA           >   COPY public."dModels" ("dModelsId", "dModelName") FROM stdin;
    public          postgres    false    220   �/       4          0    16419    sns 
   TABLE DATA           �   COPY public.sns ("snsId", sn, mac, dmodel, rev, tmodel, name, condition, "condDate", "order", place, shiped, "shipedDate", "shippedDest", "takenDate", "takenDoc", "takenOrder") FROM stdin;
    public          postgres    false    219   �/       2          0    16410    tModels 
   TABLE DATA           ?   COPY public."tModels" ("tModelsId", "tModelsName") FROM stdin;
    public          postgres    false    217   y3       0          0    16401    users 
   TABLE DATA           P   COPY public.users (userid, login, pass, email, name, access, token) FROM stdin;
    public          postgres    false    215   �3       @           0    0    sns_snsId_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."sns_snsId_seq"', 103, true);
          public          postgres    false    218            A           0    0    tModels_tModelsId_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."tModels_tModelsId_seq"', 2, true);
          public          postgres    false    216            B           0    0    users_userid_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.users_userid_seq', 3, true);
          public          postgres    false    214            �           2606    16468    condNames condNames_pkey 
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
       public            postgres    false    220            �           2606    16408    users login_unic 
   CONSTRAINT     L   ALTER TABLE ONLY public.users
    ADD CONSTRAINT login_unic UNIQUE (login);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT login_unic;
       public            postgres    false    215            �           2606    16430    sns sns_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_pkey PRIMARY KEY ("snsId");
 6   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_pkey;
       public            postgres    false    219            �           2606    16415    tModels tModels_pkey 
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
       public            postgres    false    215            �           2606    16474    sns sns_condition_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_condition_fkey FOREIGN KEY (condition) REFERENCES public."condNames"("condNamesId") NOT VALID;
 @   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_condition_fkey;
       public          postgres    false    3228    221    219            �           2606    16469    sns sns_dmodel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_dmodel_fkey FOREIGN KEY (dmodel) REFERENCES public."dModels"("dModelsId") NOT VALID;
 =   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_dmodel_fkey;
       public          postgres    false    219    220    3224            �           2606    16431    sns sns_tmodel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sns
    ADD CONSTRAINT sns_tmodel_fkey FOREIGN KEY (tmodel) REFERENCES public."tModels"("tModelsId") NOT VALID;
 =   ALTER TABLE ONLY public.sns DROP CONSTRAINT sns_tmodel_fkey;
       public          postgres    false    219    217    3218            6   +   x�3�0��V����]�x��{/��2⼰E F��� U�      5   A   x�3估��֋��.컰�b���
6\�{a��v\�y���.�e��Z\���g����� ���      4   p  x���MjA�����C�����9@��b/Z8
�������M �#�򌺾7Ɏ�r}?ޯ/�����׆��Q�#Ν9���1�<�'|����p��)��7n)v|{����I��}���ן�>�\_�����%����y�<g�+�6�y�ț��f`K�x.ۍ[E �xr��d�g �h�@,��"O�"O���*O�*7������b`I���NI=4��$=4���C����CcM�CC�=4I=4��$=4���C��p������ל�o�*���.Ij�X�%���5o�$׼�.�pIz����.I�Y�͒��Q���,Im�pq.�<t���C���1���%��Qlg�]RlG���vI��v�%�v�Yl��9`]2`R�R\"% �)�%RR�R\"% %(%$RR�RB"% %(%$RR�RB"% %(%$RR�RB"% %(%$RR�RB"%!%(%$RR�RB"%!%)%%RR�RRs;)I))������)	)I))������)	)I))�2�N�������R&�̭<����v��_Yl>G��q��)To�z��e\������58�FI���0$�P8���d��0y�)�����)���Z�%���Z�%��^{]��Z�qP��\1R�#�$#�0R�#�$#�`�h�$#uCJQJI�lH)J)��)E)%��!eSʖHِ�)eK�lHٔ�%R6�lJ�)R6�l����)eK�lHٔ�%RR6�l����M)["�!eSʖHiHiJi�������HiHiJi�������HiHiJi�������HiHiJi���*M*-�r�=G"�������Қ�/ǩ�~�V��h�Inw��x�֒@x^���$]\��ܫ|�r�\� B�Q      2      x�3�I-.1*�2����=... Z�c      0   y  x����R�@���]�$1�t@�ȉl2��B�&C6�FH�R[{_����7r�qƱ������G�&��ˢ�R�<�,ō/r�>�=}������'q�=�Nclb�-H��v3V����z[`M�r���/���mg�`eh�t�CU_�}��4��n��n�j�d�\b�if�� �Y_o,$�@D���~r$Z����)��3�|â�����?K�y?Y�+�%.Lr<礫p�-;y��7�#}�o��������-��������~`+ht ���&�$K� �S�+V�VD4튦�(=2c�%#D��,#̖�{������G�N�-L"p�ua�4?��s�^W��VPi��Ǌ���0�F�����'{��1     