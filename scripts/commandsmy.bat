oc delete all --all
oc delete pvc --all
oc delete configmap --all
oc delete secret --all

docker login
cd C:\PyCharm\openShift_SQL_docker_project
docker build -t 0533orel/data-loader-api:v2 .

לא חייב
docker run -d -p 8000:8000 --name data-loader 0533orel/data-loader-api:v2
docker ps

docker push 0533orel/data-loader-api:v2

oc login וכו'...
cd C:\PyCharm\openShift_SQL_docker_project\infrastructure\k8s
oc apply -f main-.yaml -n 0533orel-dev
oc get pods -n 0533orel-dev -l app=mysql

לא חייב
oc expose svc data-loader-api -n 0533orel-dev
oc get route data-loader-api -n 0533orel-dev

cd C:\PyCharm\openShift_SQL_docker_project\scripts
oc cp ./create_data.sql  mysql-db964b4d5-w7jwz:/tmp/create_data.sql  -n 0533orel-dev
oc cp ./insert_data.sql  mysql-db964b4d5-w7jwz:/tmp/insert_data.sql  -n 0533orel-dev

# 1) כניסה לפוד
oc rsh -n 0533orel-dev mysql-db964b4d5-w7jwz


מחיקה אם צריך פץוך הפוד
oc exec -n 0533orel-dev mysql-db964b4d5-jv8fn -- rm -f /tmp/create_data.sql /tmp/insert_data.sql


# 2) לוודא שהקבצים שם
ls -l /tmp/create_data.sql /tmp/insert_data.sql

# 3) לוודא שה-DB חי
/opt/bitnami/mysql/bin/mysqladmin ping -h 127.0.0.1 -uroot -p"$MYSQL_ROOT_PASSWORD"

# 4) להריץ את הסקריפטים
/opt/bitnami/mysql/bin/mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" -e "SOURCE /tmp/create_data.sql;"
/opt/bitnami/mysql/bin/mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" -e "SOURCE /tmp/insert_data.sql;"

# 5) אימות
/opt/bitnami/mysql/bin/mysql -u root -p"$MYSQL_ROOT_PASSWORD" -D"$MYSQL_DATABASE" -e "SHOW TABLES;"
/opt/bitnami/mysql/bin/mysql -u root -p"$MYSQL_ROOT_PASSWORD" -D"$MYSQL_DATABASE" -e "SELECT COUNT(*) AS rows_in_data FROM data;"
exit




