from RentModels import *
from sqlalchemy import case, desc

''' Функции для работы с клиентами '''
def ClientsSum():   # Вывод всех клиентов + потраченная ими сумма за все время
    res = []
    with (Session(engine) as session):
        statement = select(checks.id_card,
                            func.sum(checks.total_price) + func.sum(func.coalesce(returns.surcharge, 0))). \
            select_from(checks). \
            outerjoin(returns, returns.id == checks.id). \
            group_by(checks.id_card)
        results = session.exec(statement)
        if results:
            for result in results:
                client = 'UUID=' + str(result.id_card)
                client += ', Sum=' + str(result[1])
                res += [client]
    return res

def ClientsCount(): # Вывод всех клиентов + кол-во взятого оборудования за все время
    res = []
    with Session(engine) as session:
        statement = select(clients.id_card, func.count(clients.id_card)). \
            join(checks).join(check_line). \
            group_by(clients.id_card)
        results = session.exec(statement)
        if results:
            for result in results:
                client = 'UUID=' + str(result.id_card)
                client += ', Count=' + str(result[1])
                res += [client]
    return res

def clientDiscount(id_card):
    with (Session(engine) as session):
        statement1 = select(checks.id_card,
                            func.sum(checks.total_price) + func.sum(func.coalesce(returns.surcharge, 0))). \
            select_from(checks). \
            outerjoin(returns, returns.id == checks.id).where(checks.id_card == id_card). \
            group_by(checks.id_card, )
        results1 = session.exec(statement1).first()
        statement2 = select(clients.id_card, func.count(clients.id_card)).join(checks).join(check_line). \
            where(checks.id_card == id_card).group_by(clients.id_card, clients.first_name, clients.surname)
        results2 = session.exec(statement2).first()
        if results1 or results2:
            if   results1[1] > 10000 or results2[1] > 10:
                return 0.05
            elif results1[1] > 15000 or results2[1] > 15:
                return 0.1
            elif results1[1] > 20000 or results2[1] > 20:
                return 0.2
            elif results1[1] > 30000 or results2[1] > 30:
                return 0.25
            else:
                return 0
        else:
            return 0

# Добавить нового клиента
def insertClient(phone, first_name=None, surname=None, middle_name=None, date_of_birth=None, email=None):
    with Session(engine) as session:
        session.add(clients(phone=phone, first_name=first_name, surname=surname,
                            middle_name=middle_name, date_of_birth=date_of_birth, email=email))
        session.commit()
    print("Client added successfully")


# Обновить данные клиента по его номеру телефона
def updateClient(phNum, phone=None, first_name=None, surname=None, middle_name=None, date_of_birth=None, email=None):
    id = findUUID(phNum)
    if id:
        updateClientUUID(id, phone, first_name, surname, middle_name, date_of_birth, email)
    else:
        print("Client not found")


# Обновить данные клиента по uuid
def updateClientUUID(id_card, phone=None, first_name=None, surname=None, middle_name=None, date_of_birth=None, email=None):
    with Session(engine) as session:
        statement = select(clients).where(clients.id_card == id_card)
        client = session.exec(statement).one()
        print("Client:", client)
        if phone:
            client.phone = phone
        if first_name:
            client.first_name = first_name
        if surname:
            client.surname = surname
        if middle_name:
            client.middle_name = middle_name
        if date_of_birth:
            client.date_of_birth = date_of_birth
        if email:
            client.email = email
        session.add(client)
        session.commit()
        session.refresh(client)
        print("Updated client:", client)


# Удалить клиента по его номеру телефона
def deleteClient(phNum):
    id = findUUID(phNum)
    if id:
        deleteClientUUID(id)
    else:
        print("Client not found")


# Удалить клиента по его uuid
def deleteClientUUID(id_card):
    with Session(engine) as session:
        statement = select(clients).where(clients.id_card == id_card)
        client = session.exec(statement).one()
        print("Deleted client: ", client)
        session.delete(client)
        session.commit()


def findUUID(phNum): # Найти uuid клиента по его номеру телефона
    client=None
    with Session(engine) as session:
        statement = select(clients).where(clients.phone == phNum)
        results = session.exec(statement).first()
        if results:
            client = results.id_card
    return client


''' Функции для работы с оборудованием '''
def invNumsEq(a):  # Вывод инв номеров свободного оборудования(False) / оборудования в аренде(True)
    with Session(engine) as session:
        res = []
        statement = select(equipment).where(equipment.status == a)
        results = session.exec(statement)
        if results:
            for result in results:
                eq = 'inv_num=' + str(result.inv_num)
                eq += ', defects=' + str(result.defects)
                eq += ', status=' + str(result.status)
                eq += ', name=' + str(result.name)
                res += [eq]
    return res


def Eq():  # Вывод кол-ва оборудования свободного/в аренде
    res = []
    with Session(engine) as session:
        free = 0
        rent = 0
        statement = select(equipment.name, func.count(equipment.name),
                           func.count(case((equipment.status is True, 1))),
                           func.count(case((equipment.status is False, 1)))).group_by(equipment.name)
        results = session.exec(statement)
        for result in results:
            eq = 'Name=' + str(result[0])
            eq += ', Total=' + str(result[1])
            eq += ', Free=' + str(result[2])
            eq += ', Rent=' + str(result[3])
            res += [eq]
    return res


# Добавить новую категорию оборудования
def insertCategory(name, price_per_hour=None):
    with Session(engine) as session:
        session.add(category(name=name, price_per_hour=price_per_hour))
        session.commit()
    print("Category added successfully")


# Обновить категорию оборудования по наименованию
def updateCategory(name, price_per_hour=None, newName=None):
    with Session(engine) as session:
        statement = select(category).where(category.name == name)
        ctgr = session.exec(statement).one_or_none()
        if ctgr!=None:
            print("Category:", ctgr)
            if price_per_hour:
                ctgr.price_per_hour = price_per_hour
            if newName:
                ctgr.name = newName
            session.add(ctgr)
            session.commit()
            session.refresh(ctgr)
            print("Updated category:", ctgr)
        else:
            print("Category not found")


# Удалить категорию
def deleteCategory(name):
    with Session(engine) as session:
        statement = select(category).where(category.name == name)
        ctgr = session.exec(statement).one_or_none()
        if ctgr!=None:
            print("Deleted category: ", ctgr)
            session.delete(ctgr)
            session.commit()
        else:
            print("Category not found")


# Добавить новое оборудование
def insertEquipment(inv_num, name, defects=None):
    with Session(engine) as session:
        session.add(equipment(inv_num=inv_num, name=name, defects=defects, status=False))
        session.commit()
    print("Equipment added successfully")


# Обновить информацию об оборудовании по инв номеру
def updateEquipment(inv_num, name=None, defects=None):
    with Session(engine) as session:
        statement = select(equipment).where(equipment.inv_num == inv_num)
        eq = session.exec(statement).one_or_none()
        if eq!=None:
            print("Equipment:", eq)
            if name:
                eq.name = name
            if defects:
                eq.defects = defects
            session.add(eq)
            session.commit()
            session.refresh(eq)
            print("Updated equipment:", eq)
        else:
            print("Equipment not found")


# Удалить оборудование по инв номеру
def deleteEquipment(inv_num):
    with Session(engine) as session:
        statement = select(equipment).where(equipment.inv_num == inv_num)
        eq = session.exec(statement).one_or_none()
        if eq!=None:
            print("Deleted equipment: ", eq)
            session.delete(eq)
            session.commit()
        else:
            print("Equipment not found")


''' Функции для работы с чеками '''
def printChecks():  # Вывод всех чеков
    res = []
    with Session(engine) as session:
        statement = select(checks)
        results = session.exec(statement)
        if results:
            for result in results:
                ch = ""
                ch += "id=" + str(result.id)
                ch += ", date=" + str(result.date)
                ch += ", rental_period=" + str(result.rental_period)
                ch += ", deposit=" + str(result.deposit)
                ch += ", price=" + str(result.price)
                ch += ", discount=" + str(result.discount)
                ch += ", total_price=" + str(result.total_price)
                ch += ", id_card=" + str(result.id_card)
                res += [ch]
    return res


def addCheck(rental_period, inv_nums, id_card=None, date=datetime.datetime.now()):  # Добавление чека
    check = checks(date=date, rental_period=rental_period, id_card=id_card)
    with Session(engine) as session:
        count = len(inv_nums)
        # Считаем количество оборудования в каждой категории
        categories = {}
        statement1 = select(equipment).where(col(equipment.inv_num).in_(inv_nums))
        results1 = session.exec(statement1)
        for res in results1:
            if res.name in categories:
                categories[res.name] += 1
            else:
                categories.update({res.name: 1})
            if res.status is True:
                return ("Equipment with this inventory number is rented already", res.inv_num)
        # Находим итоговую стоимость и залог
        price=0
        deposit=0
        statement2 = select(category).where(col(category.name).in_(categories))
        results2 = session.exec(statement2)
        for res in results2:
            price += res.price_per_hour*categories[res.name]*check.rental_period
            deposit += res.price_per_hour*categories[res.name]
        # Вычисление скидки клиента
        if id_card:
            discount = clientDiscount(id_card)
        else:
            discount = 0
        # Добавление новых элементов в чек
        check.discount = discount
        check.price = price
        check.deposit = deposit
        check.total_price = check.price*(1.0-discount)
        check.id = uuid.uuid4()
        session.add(check)  # Добавляем новый чек в таблицу
        for i in range(count):
            line = check_line(id=check.id, inv_num=inv_nums[i])   # Добавляем новую строку чека в таблицу
            session.add(line)
        # Обновление статуса оборудования
        statement4 = select(equipment).where(col(equipment.inv_num).in_(inv_nums))
        results4 = session.exec(statement4)
        for res in results4:
            res.status = 1
            session.add(res)
        session.commit()
        return ("Successful", check.id)


def deleteCheck(id):    # Удаление чека
    with Session(engine) as session:
        statement1 = select(checks).where(checks.id == id)
        ch = session.exec(statement1).one_or_none()
        if ch!=None:
            statement2 = select(check_line).where(check_line.id == id)
            lines = session.exec(statement2).all()
            nums = []
            for line in lines:
                nums += [line.inv_num]
            # Обновление статуса оборудования
            statement3 = select(equipment).where(col(equipment.inv_num).in_(nums))
            status = session.exec(statement3)
            for res in status:
                res.status = 0
                session.add(res)
            session.delete(ch)
            print("Deleted check: ", ch, nums)
        else:
            print("Check not found: ")
        session.commit()


''' Возврат оборудования '''
def equipmentCheck(inv_nums):   # Поиск uuid чека по инвентарному номеру взятого оборудования
    with Session(engine) as session:
        statement = select(checks).join(check_line).where(col(check_line.inv_num).in_(inv_nums)). \
                    order_by(desc(checks.date))
        results = session.exec(statement).first()
        print(results.id)
        return results.id


def ReturnEq(id, time=datetime.datetime.now()):
    with Session(engine) as session:
        statement1 = select(checks).where(checks.id == id)
        ch = session.exec(statement1).one_or_none()
        # Обновление статуса оборудования
        if ch!=None:
            statement2 = select(check_line).where(check_line.id == id)
            lines = session.exec(statement2).all()
            nums = []
            for line in lines:
                nums += [line.inv_num]
            statement3 = select(equipment).where(col(equipment.inv_num).in_(nums))
            status = session.exec(statement3)
            for res in status:
                res.status = 0
                session.add(res)
            # Расчет доплаты
            if (ch.date + datetime.timedelta(hours=ch.rental_period) + datetime.timedelta(minutes=10)) < time:
                rentPeriod = (time - ch.date).total_seconds()/60
                delta = rentPeriod - ch.rental_period*60
                price_per_min = ch.total_price/(ch.rental_period*60)
                price = round(delta * price_per_min,2)
                session.add(returns(id=id, return_time=time, surcharge=price))
            else:
                session.add(returns(id=id, return_time=time))
                price = 0
            session.commit()
            if price:
                return ("The return was completed successfully",
                        "The amount of the surcharge is", price)
            else:
                return ("The return was completed successfully",
                        "The surcharge is not required")
        else:
            return ("check`s id not found")
