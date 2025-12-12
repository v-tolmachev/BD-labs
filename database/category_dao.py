from database.connection import get_connection


class CategoryDAO:
    @staticmethod
    def get_all():
        conn = get_connection()
        cursor = conn.get_cursor()
        cursor.execute("SELECT * FROM category ORDER BY category_id;")
        categories = cursor.fetchall()
        cursor.close()
        return categories

    @staticmethod
    def create(category_name, description):
        conn = get_connection()
        cursor = conn.get_cursor()
        cursor.execute(
            "INSERT INTO category (category_name, description) VALUES (%s, %s) RETURNING category_id;",
            (category_name, description)
        )
        category_id = cursor.fetchone()['category_id']
        conn.commit()
        cursor.close()
        return category_id

    @staticmethod
    def update(category_id, category_name, description):
        conn = get_connection()
        cursor = conn.get_cursor()
        cursor.execute(
            "UPDATE category SET category_name = %s, description = %s WHERE category_id = %s;",
            (category_name, description, category_id)
        )
        conn.commit()
        cursor.close()
        return cursor.rowcount > 0

    @staticmethod
    def delete(category_id):
        conn = get_connection()
        cursor = conn.get_cursor()
        cursor.execute("DELETE FROM category WHERE category_id = %s;", (category_id,))
        conn.commit()
        cursor.close()
        return cursor.rowcount > 0