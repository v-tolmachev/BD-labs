from database.product_dao import ProductDAO
from database.customer_dao import CustomerDAO
from database.category_dao import CategoryDAO
from database.order_dao import OrderDAO
from services.analytics import AnalyticsService


def display_products():
    print("\nВсе товары:")
    products = ProductDAO.get_all()

    if not products:
        print("Товары не найдены")
        return

    print(f"{'ID':<5} {'Название':<30} {'Цена':<10} {'Производитель':<20} {'Категория':<15}")
    print("-" * 85)
    for p in products:
        print(f"{p['product_id']:<5} {p['name']:<30} {p['price']:<10.2f} "
              f"{p['manufacturer_name']:<20} {p['category_name']:<15}")


def create_product():
    print("\nСоздание товара:")

    name = input("Название товара: ")
    description = input("Описание: ")
    price = float(input("Цена: "))
    manufacturer_id = int(input("ID производителя: "))
    category_id = int(input("ID категории: "))

    product_id = ProductDAO.create(name, description, price, manufacturer_id, category_id)
    print(f"Товар создан. ID: {product_id}")


def update_product():
    print("\nОбновление товара:")

    product_id = int(input("ID товара для обновления: "))

    product = ProductDAO.get_by_id(product_id)
    if not product:
        print("Товар не найден")
        return

    print(f"Текущие данные: {product['name']} - {product['price']} руб.")

    name = input(f"Новое название [{product['name']}]: ") or product['name']
    description = input(f"Новое описание [{product['description']}]: ") or product['description']
    price = float(input(f"Новая цена [{product['price']}]: ") or product['price'])
    manufacturer_id = int(
        input(f"Новый ID производителя [{product['manufacturer_id']}]: ") or product['manufacturer_id'])
    category_id = int(input(f"Новый ID категории [{product['category_id']}]: ") or product['category_id'])

    success = ProductDAO.update(product_id, name, description, price, manufacturer_id, category_id)
    if success:
        print("Товар обновлен")
    else:
        print("Ошибка при обновлении")


def delete_product():
    print("\nУдаление товара:")

    product_id = int(input("ID товара для удаления: "))

    confirm = input(f"Удалить товар {product_id}? (да/нет): ")
    if confirm.lower() != 'да':
        print("Отменено")
        return

    success = ProductDAO.delete(product_id)
    if success:
        print("Товар удален")
    else:
        print("Товар не найден")


def display_customers_with_orders():
    print("\nКлиенты и их заказы:")

    customer_id = int(input("ID клиента (0 - показать всех): "))

    if customer_id == 0:
        customers = CustomerDAO.get_all()
        for customer in customers:
            print(f"{customer['customer_id']}: {customer['full_name']} - {customer['email']}")
    else:
        result = CustomerDAO.get_with_orders(customer_id)
        if not result:
            print("Клиент не найден")
            return

        customer = result[0]
        print(f"\nКлиент: {customer['full_name']} ({customer['email']})")
        print("Заказы:")

        orders = [r for r in result if r['order_id']]
        if orders:
            for order in orders:
                print(f"  Заказ #{order['order_id']}: {order['total_amount']} руб. ({order['status']})")
        else:
            print("  Заказов нет")


def show_top_selling_products():
    print("\nТоп продаваемых товаров:")

    limit = int(input("Сколько товаров показать (5): ") or 5)

    top_products = AnalyticsService.get_top_selling_products(limit)

    if not top_products:
        print("Нет данных о продажах")
        return

    print(f"\n{'Название':<30} {'Производитель':<20} {'Продано шт.':<12} {'Выручка':<12}")
    print("-" * 74)
    for p in top_products:
        print(f"{p['name']:<30} {p['manufacturer_name']:<20} "
              f"{p['total_sold']:<12} {p['total_revenue']:<12.2f}")


def show_sales_by_period():
    print("\nПродажи по категориям:")

    start_date = input("Начальная дата (ГГГГ-ММ-ДД): ")
    end_date = input("Конечная дата (ГГГГ-ММ-ДД): ")

    sales = AnalyticsService.get_sales_by_period(start_date, end_date)

    if not sales:
        print("Нет данных за указанный период")
        return

    print(f"\n{'Категория':<20} {'Заказов':<10} {'Товаров продано':<15} {'Выручка':<12}")
    print("-" * 57)
    total_revenue = 0
    for s in sales:
        print(f"{s['category_name']:<20} {s['order_count']:<10} "
              f"{s['items_sold']:<15} {s['total_revenue']:<12.2f}")
        total_revenue += s['total_revenue']
    print("-" * 57)
    print(f"{'ИТОГО':<45} {total_revenue:<12.2f}")


def display_categories():
    print("\nВсе категории:")
    categories = CategoryDAO.get_all()

    if not categories:
        print("Категории не найдены")
        return

    print(f"{'ID':<5} {'Название':<25} {'Описание':<40}")
    print("-" * 75)
    for cat in categories:
        desc = cat['description']
        if desc and len(desc) > 35:
            desc = desc[:35] + "..."
        print(f"{cat['category_id']:<5} {cat['category_name']:<25} {desc:<40}")


def create_category():
    print("\nСоздание категории:")

    category_name = input("Название категории: ")
    description = input("Описание: ")

    if not category_name:
        print("Название категории обязательно!")
        return

    try:
        category_id = CategoryDAO.create(category_name, description)
        print(f"Категория создана. ID: {category_id}")
    except Exception as e:
        print(f"Ошибка при создании: {e}")


def update_category():
    print("\nОбновление категории:")

    try:
        category_id = int(input("ID категории для обновления: "))
    except ValueError:
        print("Некорректный ID")
        return

    categories = CategoryDAO.get_all()
    category_exists = any(cat['category_id'] == category_id for cat in categories)

    if not category_exists:
        print("Категория с таким ID не найдена")
        return

    current_category = next((cat for cat in categories if cat['category_id'] == category_id), None)

    print(f"Текущие данные: {current_category['category_name']}")

    category_name = input(f"Новое название [{current_category['category_name']}]: ") or current_category['category_name']
    description = input(f"Новое описание [{current_category['description']}]: ") or current_category['description']

    try:
        success = CategoryDAO.update(category_id, category_name, description)
        if success:
            print("Категория обновлена")
        else:
            print("Ошибка при обновлении")
    except Exception as e:
        print(f"Ошибка: {e}")


def delete_category():
    print("\nУдаление категории:")

    try:
        category_id = int(input("ID категории для удаления: "))
    except ValueError:
        print("Некорректный ID")
        return

    confirm = input(f"Удалить категорию {category_id}? (да/нет): ")
    if confirm.lower() != 'да':
        print("Отменено")
        return

    try:
        success = CategoryDAO.delete(category_id)
        if success:
            print("Категория удалена")
        else:
            print("Категория не найдена или есть связанные товары")
    except Exception as e:
        print(f"Ошибка при удалении: {e}")


def category_menu():
    while True:
        print("\n" + "=" * 40)
        print("Управление категориями")
        print("=" * 40)
        print("1. Показать все категории")
        print("2. Создать новую категорию")
        print("3. Обновить категорию")
        print("4. Удалить категорию")
        print("0. Назад в главное меню")

        choice = input("Выберите действие: ")

        try:
            if choice == "1":
                display_categories()
            elif choice == "2":
                create_category()
            elif choice == "3":
                update_category()
            elif choice == "4":
                delete_category()
            elif choice == "0":
                break
            else:
                print("Неверный выбор")
        except Exception as e:
            print(f"Ошибка: {e}")


def create_order():
    print("\nСоздание заказа:")

    try:
        customer_id = int(input("ID клиента: "))
        employee_id = int(input("ID сотрудника: "))
        total_amount = float(input("Общая сумма: "))
        status = input("Статус (new): ") or "new"

        order_id = OrderDAO.create_order(customer_id, employee_id, total_amount, status)
        print(f"Заказ создан. ID: {order_id}")

        add_more = "да"
        while add_more.lower() == "да":
            product_id = int(input("ID товара: "))
            quantity = int(input("Количество: "))
            unit_price = float(input("Цена за единицу: "))

            success = OrderDAO.add_product_to_order(order_id, product_id, quantity, unit_price)
            if success:
                print("Товар добавлен в заказ")
            else:
                print("Ошибка при добавлении товара")

            add_more = input("Добавить еще товар? (да/нет): ")

    except ValueError:
        print("Некорректный ввод данных")
    except Exception as e:
        print(f"Ошибка при создании заказа: {e}")


def view_order_with_items():
    print("\nПросмотр заказа:")

    try:
        order_id = int(input("ID заказа: "))
        order_data = OrderDAO.get_order_with_items(order_id)

        if not order_data:
            print("Заказ не найден")
            return

        order = order_data[0]
        print(f"\nЗаказ #{order['order_id']}")
        print(f"Дата: {order['order_date']}")
        print(f"Клиент: {order['customer_name']}")
        print(f"Сумма: {order['total_amount']} руб.")
        print(f"Статус: {order['status']}")
        print("\nТовары в заказе:")

        has_items = False
        for item in order_data:
            if item['product_name']:
                has_items = True
                print(f"  - {item['product_name']}: {item['quantity']} шт. по {item['unit_price']} руб.")

        if not has_items:
            print("  В заказе нет товаров")

    except ValueError:
        print("Некорректный ID заказа")
    except Exception as e:
        print(f"Ошибка: {e}")


def show_customer_stats():
    print("\nСтатистика по клиентам:")

    try:
        stats = AnalyticsService.get_customer_purchase_stats()

        if not stats:
            print("Нет данных о клиентах")
            return

        print(f"\n{'Клиент':<25} {'Email':<25} {'Заказов':<10} {'Потратил':<12} {'Последний заказ':<20}")
        print("-" * 95)
        for stat in stats:
            last_order = stat['last_order_date'] if stat['last_order_date'] else "нет заказов"
            total_spent = stat['total_spent'] if stat['total_spent'] else 0
            orders_count = stat['total_orders'] if stat['total_orders'] else 0

            print(f"{stat['full_name']:<25} {stat['email']:<25} {orders_count:<10} "
                  f"{total_spent:<12.2f} {last_order:<20}")

    except Exception as e:
        print(f"Ошибка: {e}")


def order_menu():
    while True:
        print("\n" + "=" * 40)
        print("Управление заказами")
        print("=" * 40)
        print("1. Создать новый заказ")
        print("2. Просмотреть заказ с товарами")
        print("0. Назад в главное меню")

        choice = input("Выберите действие: ")

        try:
            if choice == "1":
                create_order()
            elif choice == "2":
                view_order_with_items()
            elif choice == "0":
                break
            else:
                print("Неверный выбор")
        except Exception as e:
            print(f"Ошибка: {e}")


def main_menu():
    while True:
        print("\n" + "=" * 50)
        print("Управление базой данных магазина")
        print("=" * 50)
        print("1. Показать все товары")
        print("2. Создать новый товар")
        print("3. Обновить товар")
        print("4. Удалить товар")
        print("5. Показать клиентов и их заказы")
        print("6. Топ продаваемых товаров")
        print("7. Продажи по категориям за период")
        print("8. Управление категориями")
        print("9. Управление заказами")
        print("10. Статистика по клиентам")
        print("0. Выход")

        choice = input("Выберите действие: ")

        try:
            if choice == "1":
                display_products()
            elif choice == "2":
                create_product()
            elif choice == "3":
                update_product()
            elif choice == "4":
                delete_product()
            elif choice == "5":
                display_customers_with_orders()
            elif choice == "6":
                show_top_selling_products()
            elif choice == "7":
                show_sales_by_period()
            elif choice == "8":
                category_menu()
            elif choice == "9":
                order_menu()
            elif choice == "10":
                show_customer_stats()
            elif choice == "0":
                print("Выход...")
                break
            else:
                print("Неверный выбор")
        except Exception as e:
            print(f"Ошибка: {e}")


if __name__ == "__main__":
    main_menu()