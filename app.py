from database.product_dao import ProductDAO
from database.customer_dao import CustomerDAO
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


def main_menu():
    while True:
        print("\n" + "=" * 40)
        print("Управление базой данных магазина")
        print("=" * 40)
        print("1. Показать все товары")
        print("2. Создать новый товар")
        print("3. Обновить товар")
        print("4. Удалить товар")
        print("5. Показать клиентов и их заказы")
        print("6. Топ продаваемых товаров")
        print("7. Продажи по категориям за период")
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
            elif choice == "0":
                print("Выход...")
                break
            else:
                print("Неверный выбор")
        except Exception as e:
            print(f"Ошибка: {e}")


if __name__ == "__main__":
    main_menu()