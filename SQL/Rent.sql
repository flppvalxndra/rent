PGDMP                         {            Rent    14.9    14.9     '           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            (           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            )           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            *           1262    17469    Rent    DATABASE     c   CREATE DATABASE "Rent" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "Rent";
                postgres    false                        3079    17473 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            +           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    2            �            1259    18460    category    TABLE     t   CREATE TABLE public.category (
    name character varying NOT NULL,
    price_per_hour double precision NOT NULL
);
    DROP TABLE public.category;
       public         heap    postgres    false            �            1259    18506 
   check_line    TABLE     a   CREATE TABLE public.check_line (
    id uuid NOT NULL,
    inv_num character varying NOT NULL
);
    DROP TABLE public.check_line;
       public         heap    postgres    false            �            1259    18467    checks    TABLE     �  CREATE TABLE public.checks (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    date timestamp without time zone NOT NULL,
    rental_period integer NOT NULL,
    deposit double precision DEFAULT '0'::double precision NOT NULL,
    price double precision DEFAULT '0'::double precision NOT NULL,
    discount double precision DEFAULT '0'::double precision NOT NULL,
    total_price double precision DEFAULT '0'::double precision NOT NULL,
    id_card uuid
);
    DROP TABLE public.checks;
       public         heap    postgres    false    2            �            1259    18451    clients    TABLE       CREATE TABLE public.clients (
    id_card uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying,
    surname character varying,
    middle_name character varying,
    date_of_birth date,
    phone character varying NOT NULL,
    email character varying
);
    DROP TABLE public.clients;
       public         heap    postgres    false    2            �            1259    18483 	   equipment    TABLE     �   CREATE TABLE public.equipment (
    inv_num character varying NOT NULL,
    defects character varying,
    status boolean DEFAULT false NOT NULL,
    name character varying NOT NULL
);
    DROP TABLE public.equipment;
       public         heap    postgres    false            �            1259    18496    returns    TABLE     �   CREATE TABLE public.returns (
    id uuid NOT NULL,
    return_time timestamp without time zone NOT NULL,
    surcharge double precision
);
    DROP TABLE public.returns;
       public         heap    postgres    false                       0    18460    category 
   TABLE DATA           8   COPY public.category (name, price_per_hour) FROM stdin;
    public          postgres    false    211   ;#       $          0    18506 
   check_line 
   TABLE DATA           1   COPY public.check_line (id, inv_num) FROM stdin;
    public          postgres    false    215   �#       !          0    18467    checks 
   TABLE DATA           i   COPY public.checks (id, date, rental_period, deposit, price, discount, total_price, id_card) FROM stdin;
    public          postgres    false    212   a$                 0    18451    clients 
   TABLE DATA           i   COPY public.clients (id_card, first_name, surname, middle_name, date_of_birth, phone, email) FROM stdin;
    public          postgres    false    210   �%       "          0    18483 	   equipment 
   TABLE DATA           C   COPY public.equipment (inv_num, defects, status, name) FROM stdin;
    public          postgres    false    213   f&       #          0    18496    returns 
   TABLE DATA           =   COPY public.returns (id, return_time, surcharge) FROM stdin;
    public          postgres    false    214   s'       �           2606    18466    category category_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (name);
 @   ALTER TABLE ONLY public.category DROP CONSTRAINT category_pkey;
       public            postgres    false    211            �           2606    18512    check_line check_line_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.check_line
    ADD CONSTRAINT check_line_pkey PRIMARY KEY (id, inv_num);
 D   ALTER TABLE ONLY public.check_line DROP CONSTRAINT check_line_pkey;
       public            postgres    false    215    215            �           2606    18476    checks checks_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.checks
    ADD CONSTRAINT checks_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.checks DROP CONSTRAINT checks_pkey;
       public            postgres    false    212            �           2606    18458    clients clients_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id_card);
 >   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pkey;
       public            postgres    false    210            �           2606    18490    equipment equipment_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (inv_num);
 B   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_pkey;
       public            postgres    false    213            �           2606    18500    returns returns_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.returns
    ADD CONSTRAINT returns_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.returns DROP CONSTRAINT returns_pkey;
       public            postgres    false    214            �           1259    18482    ix_checks_id    INDEX     =   CREATE INDEX ix_checks_id ON public.checks USING btree (id);
     DROP INDEX public.ix_checks_id;
       public            postgres    false    212            �           1259    18459    ix_clients_id_card    INDEX     I   CREATE INDEX ix_clients_id_card ON public.clients USING btree (id_card);
 &   DROP INDEX public.ix_clients_id_card;
       public            postgres    false    210            �           2606    18513    check_line check_line_id_fkey    FK CONSTRAINT     x   ALTER TABLE ONLY public.check_line
    ADD CONSTRAINT check_line_id_fkey FOREIGN KEY (id) REFERENCES public.checks(id);
 G   ALTER TABLE ONLY public.check_line DROP CONSTRAINT check_line_id_fkey;
       public          postgres    false    3207    215    212            �           2606    18518 "   check_line check_line_inv_num_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.check_line
    ADD CONSTRAINT check_line_inv_num_fkey FOREIGN KEY (inv_num) REFERENCES public.equipment(inv_num);
 L   ALTER TABLE ONLY public.check_line DROP CONSTRAINT check_line_inv_num_fkey;
       public          postgres    false    213    3210    215            �           2606    18477    checks checks_id_card_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.checks
    ADD CONSTRAINT checks_id_card_fkey FOREIGN KEY (id_card) REFERENCES public.clients(id_card);
 D   ALTER TABLE ONLY public.checks DROP CONSTRAINT checks_id_card_fkey;
       public          postgres    false    3202    210    212            �           2606    18491    equipment equipment_name_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_name_fkey FOREIGN KEY (name) REFERENCES public.category(name);
 G   ALTER TABLE ONLY public.equipment DROP CONSTRAINT equipment_name_fkey;
       public          postgres    false    213    3205    211            �           2606    18501    returns returns_id_fkey    FK CONSTRAINT     r   ALTER TABLE ONLY public.returns
    ADD CONSTRAINT returns_id_fkey FOREIGN KEY (id) REFERENCES public.checks(id);
 A   ALTER TABLE ONLY public.returns DROP CONSTRAINT returns_id_fkey;
       public          postgres    false    214    3207    212                @   x�+��/O�O,J�4450�J.�/.�M�/�+)��/����K�44 ����@vIi������ /T      $   �   x���1r�!�z�DPh�GؔiT��G��O`ü���t�]aX80M��6�݂����|#�2o)��VB0�e��݁�LP>	=7�X۶�~�ה
�f�ɠ�ܬ�2���
Mm3��)��09��N'!�%�ڵ������Z{�/����0��Z.�XB���T��8yB�<g9;h��-v7JMy���T�i/�_��?r��b      !   7  x����m1���V�hP|H��H�P��	Ѯa 1` !	�FCO�h�0�Nr_A �	q,�!4�_M���_�=���_��(M�eR�a/@o!6f�k+�1k�ct��&�ì +f�d�H7R$�ނ���&W���&��9����_�yj��en����k���������o�>���0�OpgR�!ui�vb�<E����,A�%�~�� ������ZߙA·�=8��e��Rf�6N���N��M�䟒`-X�>���ʟ����xV>�qo�/S�ϝ�]���%�5         �   x�U�;n1��s
_����D9�6��D��=<�ۤҧ�1�҉s� Y��@/!�Y��~��G����G*f�@�z�sV�̜���`�a���8�P��7�1V��y��l�j�H��B_b�=�*�8��q��O'kn�ΤM�3�}dܟz����oo�q�<k=0      "   �   x���K�P���b����2hs[
QF!��ѿ�Az�39�� �;zǮ���x'�����ٷG߾0�0�IB��HHJM1ω���m�u��������.UU�?y�䑒�J�(y���|�O�o�Jn�\�+����5Q�#81 H�� 	H
�Me��@g���:��v5��z;��$ )H6��?� $ 	A�3Cg���:�q�����Ik�`ml�
�C0��})�KCs�κ�������;,���?�f��      #   �   x�]�͉�1D�q_
�����b[v�%�Y��0��<���d-V�rG�c2h����7Ff ���x�Fհh���<s�JTc�qw��׋@��M?�2\-�����V��z��m̘�Œ�Xv����2��p������ƙ����m���o;�'+�����$���ƇweK�d�x�&8e߲f޾?���@{��{)��V5     