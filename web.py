# uvicorn web:app --reload
from fastapi import FastAPI
from typing import Optional
from fastapi.responses import FileResponse
from pydantic import BaseModel
import datetime
import RentSelect as rs
import uuid


class ClientForm(BaseModel):
    first_name: Optional[str] = None
    surname: Optional[str] = None
    middle_name: Optional[str] = None
    date_of_birth: Optional[datetime.date] = None
    phone: str
    email: Optional[str] = None


class ClientFormUpdate(BaseModel):
    phone: str
    first_name: Optional[str] = None
    surname: Optional[str] = None
    middle_name: Optional[str] = None
    date_of_birth: Optional[datetime.date] = None
    newPhone: Optional[str] = None
    email: Optional[str] = None


class ClientFormDelete(BaseModel):
    phone: str


# ================================================================================
class StatusEq(BaseModel):
    status: bool


class CategoryForm(BaseModel):
    name: str
    price_per_hour: Optional[float] = None


class CategoryFormUpdate(BaseModel):
    name: str
    price_per_hour: Optional[float] = None
    newName: Optional[str] = None


class CategoryFormDelete(BaseModel):
    name: str


# ------------------------------------------------------------
class EquipmentForm(BaseModel):
    inv_num: str
    name: str
    defects: Optional[str] = None

class EquipmentFormUpdate(BaseModel):
    inv_num: str
    name: Optional[str] = None
    defects: Optional[str] = None
class EquipmentFormDelete(BaseModel):
    inv_num: str


# ================================================================================
class OrderForm(BaseModel):
    date: Optional[datetime.datetime] = None
    rental_period: int
    inv_nums: list
    id_card: Optional[uuid.UUID] = None


class OrderFormDelete(BaseModel):
    id: uuid.UUID


class ReturnForm(BaseModel):
    id: uuid.UUID
    date: Optional[datetime.datetime] = datetime.datetime.now()


# ================================================================================
app = FastAPI()


@app.get("/")
async def root():
     return FileResponse("index.html")


@app.post("/allClientsSum")
async def allClientsSum():
    return rs.ClientsSum()


@app.post("/allClientsCount")
async def allClientsCount():
    return rs.ClientsCount()

@app.post("/addClient")
async def addClient(data: ClientForm):
    print(data)
    rs.insertClient(phone=data.phone, first_name=data.first_name,
                    surname=data.surname, middle_name=data.middle_name,
                    date_of_birth=data.date_of_birth, email=data.email)
    return "Данные клиента добавлены"


@app.post("/updateClient")
async def updateClient(data: ClientFormUpdate):
    print(data)
    rs.updateClient(phNum=data.phone, phone=data.newPhone, first_name=data.first_name,
                    surname=data.surname, middle_name=data.middle_name,
                    date_of_birth=data.date_of_birth, email=data.email)
    return "Данные клиента обновлены"


@app.post("/deleteClient")
async def deleteClient(data: ClientFormDelete):
    print(data)
    rs.deleteClient(phNum=data.phone)
    return "Данные клиента удалены"


# ================================================================================
@app.post("/StatusEq")
async def StatusEq(data: StatusEq):
    return rs.invNumsEq(data.status)


@app.post("/AllEq")
async def AllEq():
    return rs.Eq()


# ------------------------------------------------------------
@app.post("/addCategory")
async def addCategory(data: CategoryForm):
    print(data)
    rs.insertCategory(name=data.name, price_per_hour=data.price_per_hour)
    return "Категория добавлена"


@app.post("/updateCategory")
async def updateCategory(data: CategoryFormUpdate):
    print(data)
    rs.updateCategory(name=data.name, price_per_hour=data.price_per_hour, newName=data.newName)
    return "Категория обновлена"


@app.post("/deleteCategory")
async def deleteCategory(data: CategoryFormDelete):
    print(data)
    rs.deleteCategory(name=data.name)
    return "Категория удалена"


# ------------------------------------------------------------
@app.post("/addEquipment")
async def addEquipment(data: EquipmentForm):
    print(data)
    rs.insertEquipment(inv_num=data.inv_num, name=data.name, defects=data.defects)
    return "Оборудование добавлено"


@app.post("/updateEquipment")
async def updateEquipment(data: EquipmentFormUpdate):
    print(data)
    rs.updateEquipment(inv_num=data.inv_num, name=data.name, defects=data.defects)
    return "Оборудование обновлено"


@app.post("/deleteEquipment")
async def deleteEquipment(data: EquipmentFormDelete):
    print(data)
    rs.deleteEquipment(inv_num=data.inv_num)
    return "Оборудование удалено"


# ================================================================================
@app.post("/printChecks")
async def printChecks():
    return rs.printChecks()

@app.post("/addOrder")
async def addOrder(data: OrderForm):
    return rs.addCheck(rental_period=data.rental_period, inv_nums=data.inv_nums, id_card=data.id_card,
                date=data.date)

@app.post("/deleteCheck")
async def deleteCheck(data: OrderFormDelete):
    rs.deleteCheck(id=data.id)
    return "Заказ удален"

@app.post("/addReturn")
async def addReturn(data: ReturnForm):
    return rs.ReturnEq(id=data.id, time=data.date)
