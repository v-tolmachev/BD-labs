# test_connection.py
from database.connection import get_connection

try:
    conn = get_connection()
    cursor = conn.get_cursor()

    cursor.execute("SELECT COUNT(*) as count FROM product;")
    result = cursor.fetchone()

    print(f"✅ Подключение успешно!")
    print(f"✅ В таблице product: {result['count']} записей")

    cursor.close()

except Exception as e:
    print(f"❌ Ошибка подключения: {e}")
    print("\nВозможные причины:")
    print("1. Неверные параметры в connection.py (проверьте пароль)")
    print("2. База my_shop не существует")
    print("3. PostgreSQL не запущен")