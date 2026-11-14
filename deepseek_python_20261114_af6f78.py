from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

# Создаем наш сервер (того самого "путеводителя")
app = FastAPI()

# Настройка CORS (чтобы Flutter мог стучаться к серверу)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # В реальном проекте тут будет адрес твоего приложения
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Модель данных (что мы ждем от пользователя)
class UserRegister(BaseModel):
    email: str

# Это наш "Путеводитель" (FastAPI). Он ловит запрос по адресу /register
@app.post("/register")
async def register_user(user: UserRegister):
    # Тут (в будущем) Python будет класть данные в PostgreSQL.
    # А пока он просто выводит их в консоль и отвечает пользователю.
    
    print(f"Новый пользователь зарегистрирован: {user.email}")
    
    return {"message": f"Пользователь {user.email} успешно создан!"}