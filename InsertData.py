from RentModels import *
from RentSelect import findUUID, addCheck, datetime, ReturnEq

cat1 = category(name="snowboard", price_per_hour=1500)
cat2 = category(name="cross-country_skiing", price_per_hour=1000)
cat3 = category(name="skiing", price_per_hour=1300)
cat4 = category(name="tubing", price_per_hour=500)

eq1 = equipment(inv_num="SB001", name="snowboard")
eq2 = equipment(inv_num="SB002", name="snowboard")
eq3 = equipment(inv_num="SB003", name="snowboard")
eq4 = equipment(inv_num="SB004", name="snowboard")
eq5 = equipment(inv_num="SB005", name="snowboard")
eq6 = equipment(inv_num="SB006", name="snowboard")
eq7 = equipment(inv_num="SB007", name="snowboard")
eq8 = equipment(inv_num="SB008", name="snowboard")
eq9 = equipment(inv_num="SB009", name="snowboard")
eq10 = equipment(inv_num="SB010", name="snowboard")
eq11 = equipment(inv_num="SB011", name="snowboard")
eq12 = equipment(inv_num="SB012", name="snowboard")
eq13 = equipment(inv_num="SB013", name="snowboard")
eq14 = equipment(inv_num="SB014", name="snowboard")
eq15 = equipment(inv_num="SB015", name="snowboard")
eq16 = equipment(inv_num="CC001", name="cross-country_skiing")
eq17 = equipment(inv_num="CC002", name="cross-country_skiing")
eq18 = equipment(inv_num="CC003", name="cross-country_skiing")
eq19 = equipment(inv_num="CC004", name="cross-country_skiing")
eq20 = equipment(inv_num="CC005", name="cross-country_skiing")
eq21 = equipment(inv_num="CC006", name="cross-country_skiing")
eq22 = equipment(inv_num="CC007", name="cross-country_skiing")
eq23 = equipment(inv_num="CC008", name="cross-country_skiing")
eq24 = equipment(inv_num="CC009", name="cross-country_skiing")
eq25 = equipment(inv_num="CC010", name="cross-country_skiing")
eq26 = equipment(inv_num="CC011", name="cross-country_skiing")
eq27 = equipment(inv_num="CC012", name="cross-country_skiing")
eq28 = equipment(inv_num="CC013", name="cross-country_skiing")
eq29 = equipment(inv_num="CC014", name="cross-country_skiing")
eq30 = equipment(inv_num="CC015", name="cross-country_skiing")
eq31 = equipment(inv_num="SK001", name="skiing")
eq32 = equipment(inv_num="SK002", name="skiing")
eq33 = equipment(inv_num="SK003", name="skiing")
eq34 = equipment(inv_num="SK004", name="skiing")
eq35 = equipment(inv_num="SK005", name="skiing")
eq36 = equipment(inv_num="SK006", name="skiing")
eq37 = equipment(inv_num="SK007", name="skiing")
eq38 = equipment(inv_num="SK008", name="skiing")
eq39 = equipment(inv_num="SK009", name="skiing")
eq40 = equipment(inv_num="SK010", name="skiing")
eq41 = equipment(inv_num="SK011", name="skiing")
eq42 = equipment(inv_num="SK012", name="skiing")
eq43 = equipment(inv_num="SK013", name="skiing")
eq44 = equipment(inv_num="SK014", name="skiing")
eq45 = equipment(inv_num="SK015", name="skiing")
eq46 = equipment(inv_num="TB001", name="tubing")
eq47 = equipment(inv_num="TB002", name="tubing")
eq48 = equipment(inv_num="TB003", name="tubing")
eq49 = equipment(inv_num="TB004", name="tubing")
eq50 = equipment(inv_num="TB005", name="tubing")
eq51 = equipment(inv_num="TB006", name="tubing")
eq52 = equipment(inv_num="TB007", name="tubing")
eq53 = equipment(inv_num="TB008", name="tubing")
eq54 = equipment(inv_num="TB009", name="tubing")
eq55 = equipment(inv_num="TB010", name="tubing")
eq56 = equipment(inv_num="TB011", name="tubing")
eq57 = equipment(inv_num="TB012", name="tubing")
eq58 = equipment(inv_num="TB013", name="tubing")
eq59 = equipment(inv_num="TB014", name="tubing")
eq60 = equipment(inv_num="TB015", name="tubing")
eq61 = equipment(inv_num="TB016", name="tubing")
eq62 = equipment(inv_num="TB017", name="tubing")
eq63 = equipment(inv_num="TB018", name="tubing")
eq64 = equipment(inv_num="TB019", name="tubing")
eq65 = equipment(inv_num="TB020", name="tubing")

cl1 = clients(first_name='Ivan',surname='Ivanov',
              date_of_birth=datetime.date(1999,5,23),
              phone='8 999 555 33 22')
cl2 = clients(first_name='Petrov',surname='Petr',
              date_of_birth=datetime.date(2001,9,5),
              phone='8 999 888 12 54')
cl3 = clients(first_name='Ivan',surname='Petrov',
              date_of_birth=datetime.date(1986,12,5),
              phone='8 777 555 33 22')

with Session(engine) as session:
    session.add_all([cat1, cat2, cat3, cat4])
    session.add_all([eq1,  eq2,  eq3,  eq4,  eq5,  eq6,  eq7,  eq8,  eq9, eq10, eq11, eq12, eq13, eq14, eq15,
                     eq16, eq17, eq18, eq19, eq20, eq21, eq22, eq23, eq24, eq25, eq26, eq27, eq28, eq29, eq30,
                     eq31, eq32, eq33, eq34, eq35, eq36, eq37, eq38, eq39, eq40, eq41, eq42, eq43, eq44, eq45,
                     eq46, eq47, eq48, eq49, eq50, eq51, eq52, eq53, eq54, eq55,
                     eq56, eq57, eq58, eq59, eq60, eq61, eq62, eq63, eq64, eq65
                     ])
    session.add_all([cl1, cl2, cl3])
    session.commit()

# Добавление чеков

ch1 = addCheck(date=datetime.datetime(2022,12,30,15,38),rental_period=3,
               id_card=findUUID('8 999 555 33 22'),inv_nums=['SB001','SB002','SB003'])

ch2 = addCheck(date=datetime.datetime(2023,1,2,15,58),rental_period=2,
               id_card=findUUID('8 999 888 12 54'),inv_nums=['TB001','TB002'])

ch3 = addCheck(date=datetime.datetime(2023,1,2,16),rental_period=2,
               id_card=findUUID('8 777 555 33 22'),inv_nums=['TB003','TB004'])

ch4 = addCheck(date=datetime.datetime(2023,1,2,16,10),rental_period=3,inv_nums=['CC001'])

ch5 = addCheck(date=datetime.datetime(2023,1,2,16,50),rental_period=2,inv_nums=['CC002'])

ch6 = addCheck(date=datetime.datetime(2023,1,3,15),rental_period=2,
               id_card=findUUID('8 999 555 33 22'),inv_nums=['SB004','SB005','SB006'])

# Возврат оборудования
#
# ReturnEq(id="ad5dc150-79ed-42a0-abc2-4ac3e2007b0a", time=datetime.datetime(2022,12,30,19))
# ReturnEq(id="46395ff4-8dde-4396-b991-bb852a834eae", time=datetime.datetime(2023,1,2,18))
# ReturnEq(id="e50e79fe-a0c6-465a-84c6-0dfc287bc9c5", time=datetime.datetime(2023,1,2,18,15))
# ReturnEq(id="816eddb0-4dcb-4ea9-a8cf-3fb88eb52dd6", time=datetime.datetime(2023,1,2,18,30))
# ReturnEq(id="56985dc5-8dc5-4062-8d00-9f40872c134d", time=datetime.datetime(2023,1,2,19))
# ReturnEq(id="e625d2df-15f6-4d4d-81d7-8f3ec692f8f5", time=datetime.datetime(2023,1,3,17,5))