#Dario Gomez Assignment 8.2 4/26/25
import mysql.connector
from mysql.connector import errorcode

import dotenv
from dotenv import dotenv_values


def main():
    secrets = dotenv_values(".env")

    config = {
        "user": secrets["USER"],
        "password": secrets["PASSWORD"],
        "host": secrets["HOST"],
        "database": secrets["DATABASE"],
        "raise_on_warnings": True
    }
    try:
    #""" try/catch block for handling potential MySQL database errors """
        db = mysql.connector.connect(**config)  # connect to the movies database

    # output the connection status
        print("\n  Database user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"],config["database"]))

        input("\n\n  Press any key to continue...")

    except mysql.connector.Error as err:
    #""" on error code """

        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("  The supplied username or password are invalid")

        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("  The specified database does not exist")

        else:
            print(err)

    finally:
        if 'db' in locals() and db.is_connected():
            cursor = db.cursor()
            show_films(cursor,"DISPLAYING FILMS")
            enter_film(cursor)
            show_films(cursor, "DISPLAYING FILMS AFTER INSERT")
            update_film(cursor)
            show_films(cursor, "DISPLAYING FILMS AFTER UPDATE- Changed Alien to Horror")
            delete_film(cursor)
            show_films(cursor, "DISPLAYING FILMS AFTER DELETE")

            cursor.close()
            db.close()
            print("\n  Database connection closed")
def show_films (cursor, title) :

    cursor.execute("select film_name as Name, film_director as Director, genre_name as Genre, studio_name as 'Studio Name' from film INNER JOIN genre ON film.genre_id=genre.genre_id INNER JOIN studio ON film.studio_id=studio.studio_id")

    films = cursor.fetchall()
    print ("\n -- {} --".format(title))
    for film in films:
        print ("Film Name: {}\nDirector: {}\nGenre Name ID: {}\nStudio Name: {}\n".format(film[0], film[1], film[2], film[3]))

def enter_film(cursor):
    try:
        cursor.execute(
    "INSERT INTO film (film_name, film_director, film_releaseDate,film_runtime, genre_id, studio_id) "
    "VALUES ('Logan','James Mangold','2017','137', (SELECT genre_id FROM genre WHERE genre_name = 'Drama'), "
    "(SELECT studio_id FROM studio WHERE studio_name = '20th Century Fox'))"
)

        print("Film 'Logan' added successfully.")
    except mysql.connector.Error as err:
        print(f"Error adding film: {err}")

def update_film(cursor):
    try:
        cursor.execute("UPDATE film SET film_name = 'Alien' WHERE film_name = 'Alien'")

        print("Film 'Alien' updated successfully.")
    except mysql.connector.Error as err:
        print(f"Error updating film: {err}")

def delete_film(cursor):
    try:
        cursor.execute("DELETE FROM film WHERE film_name = 'Gladiator'")

        print("Film 'Gladiator' deleted successfully.")
    except mysql.connector.Error as err:
        print(f"Error deleting film: {err}")


if __name__ == "__main__":
    main()