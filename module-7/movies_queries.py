#Dario Gomez Assignment 7.2 4/26/25
import mysql.connector
from mysql.connector import errorcode

import dotenv
from dotenv import dotenv_values

secrets = dotenv_values("/Users/dariogomez/MyDocs/Bellevue/CSD 310/csd/csd-310/module-6/.env")

config = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "database": secrets["DATABASE"],
    "raise_on_warnings": True
}
try:
    """ try/catch block for handling potential MySQL database errors """

    db = mysql.connector.connect(**config)  # connect to the movies database

    # output the connection status
    print("\n  Database user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"],
                                                                                       config["database"]))

    input("\n\n  Press any key to continue...")

except mysql.connector.Error as err:
    """ on error code """

    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("  The supplied username or password are invalid")

    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("  The specified database does not exist")

    else:
        print(err)

finally:
    if 'db' in locals() and db.is_connected():
        cursor = db.cursor()

        print('-- DISPLAYING Studio RECORDS --')
        cursor.execute('SELECT studio_id, studio_name FROM studio')
        studios = cursor.fetchall()
        for studio in studios:
            print('Studio ID: {}\n Studio Name:{}\n'.format(studio[0], studio[1]))

        print('-- DISPLAYING Genre RECORDS --')
        cursor.execute('SELECT genre_id, genre_name FROM genre')
        genres = cursor.fetchall()
        for genre in genres:
            print('Genre ID: {}\nGenre Name: {}\n'.format(genre[0], genre[1]))

        print('-- DISPLAYING Short Film RECORDS --')
        cursor.execute('SELECT film_name, film_runtime FROM film')
        films = cursor.fetchall()
        for film in films:
            print('Film Name: {}\nRuntime: {}\n'.format(film[0], film[1]))

        print('-- DISPLAYING Director RECORDS in Order --')
        cursor.execute('SELECT film_name, film_director FROM film ORDER BY film_director')
        directors = cursor.fetchall()
        for director in directors:
            print('Film Name: {}\nDirector: {}\n'.format(director[0], director[1]))

        cursor.close()
        db.close()
        print("\n  Database connection closed")


