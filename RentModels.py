from sqlalchemy import func
from sqlmodel import Field, Session, SQLModel, create_engine, select, text, col, Relationship
from typing import Optional, List
import uuid
import datetime


class clients(SQLModel, table=True):
    id_card: uuid.UUID = Field(primary_key=True, index=True, nullable=False,
                          sa_column_kwargs=dict(server_default=func.uuid_generate_v4()))
    first_name: Optional[str] = None
    surname: Optional[str] = None
    middle_name: Optional[str] = None
    date_of_birth: Optional[datetime.date] = None
    phone: str
    email: Optional[str] = None
    checks: List["checks"] = Relationship(sa_relationship_kwargs={"cascade": "save-update"})


class checks(SQLModel, table=True):
    id: uuid.UUID = Field(primary_key=True, index=True, nullable=False,
                          sa_column_kwargs=dict(server_default=func.uuid_generate_v4()))
    date: datetime.datetime = Field(nullable=False)
    rental_period: int = Field(nullable=False)
    deposit: float = Field(sa_column_kwargs=dict(server_default='0.00'))
    price: float = Field(sa_column_kwargs=dict(server_default='0.00'))
    discount: float = Field(sa_column_kwargs=dict(server_default='0.00'))
    total_price: float = Field(sa_column_kwargs=dict(server_default='0.00'))
    id_card: Optional[uuid.UUID] = Field(foreign_key=clients.id_card)
    lines: List["check_line"] = Relationship(sa_relationship_kwargs={"cascade": "delete"})
    returns: List["returns"] = Relationship(sa_relationship_kwargs={"cascade": "delete"})


class returns(SQLModel, table=True):
    id: uuid.UUID = Field(primary_key=True, nullable=False, foreign_key=checks.id)
    return_time: datetime.datetime = Field(nullable=False)
    surcharge: Optional[float] = None


class category(SQLModel, table=True):
    name: str =Field(primary_key=True, nullable=False)
    price_per_hour: float
    eq: List["equipment"] = Relationship(sa_relationship_kwargs={"cascade": "delete"})


class equipment(SQLModel, table=True):
    inv_num: str = Field(primary_key=True, nullable=False)
    defects: Optional[str] = None
    status: bool = Field(sa_column_kwargs=dict(server_default='0'))
    name: str = Field(foreign_key=category.name)


class check_line(SQLModel, table=True):
    id: uuid.UUID = Field(primary_key=True, nullable=False, foreign_key=checks.id)

    inv_num: str = Field(primary_key=True, nullable=False, foreign_key=equipment.inv_num)

# Подключение к серверу PostgreSQL на localhost с помощью psycopg2 DBAPI 
engine = create_engine("postgresql+psycopg2://postgres:1234@localhost:5432/Rent")
SQLModel.metadata.create_all(engine)

