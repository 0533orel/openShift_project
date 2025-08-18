# Data Loader Project

This project is a **Data Loader system** that demonstrates how to deploy a **FastAPI application** connected to a **MySQL database** in **OpenShift**.

The system loads initial data into the database, exposes an API for retrieving data, and shows how to manage deployments and persistence in a containerized environment.

---

## 🚀 Features

- MySQL database running inside OpenShift with Persistent Volume.
- SQL scripts (`create_data.sql` and `insert_data.sql`) to initialize and populate the database.
- FastAPI backend service (`data-loader-api`) exposing REST API endpoints.
- Deployment manifests for OpenShift (YAML files for Secret, PVC, Deployment, and Service).
- End-to-end flow: deploy → load data → access via API route.

---

## 📂 Project Structure

```
openShift_SQL_docker_project/
├── infrastructure/
│   └── k8s/
│       ├── main-.yaml               # run all yamels
│
├── scripts/
│   ├── create_data.sql              # Script to create the database table
│   ├── insert_data.sql              # Script to insert sample rows into the table
│
├── services/
│   └── data_loader/
│       ├── dal.py                   # Data Access Layer to fetch data from the DB
│
├── app.py                           # FastAPI main application
├── Dockerfile                       # Docker build for the FastAPI API
└── README.md                        # Project documentation
```

---

## ⚙️ How It Works

1. **MySQL Pod**  
   - Runs with a Persistent Volume for data storage.  
   - Credentials and DB name come from the Kubernetes Secret.  
   - Initialized using the SQL scripts.

2. **FastAPI Pod (API)**  
   - Connects to the MySQL DB.  
   - Exposes `/data` endpoint to fetch rows from the database.  
   - Deployed in the same namespace.  

3. **API Exposure**  
   - Internal Service (`ClusterIP`) is created.  
   - A Route is defined in OpenShift to expose the API outside the cluster.  
   - Example URL:  
     ```
     http://data-loader-api-<namespace>.apps.<cluster-domain>/
     ```

---

## 🛠️ How to Deploy

1. **Login to OpenShift**  
   ```bash
   oc login ...
   ```

2. **Create Namespace (if needed)**  
   ```bash
   oc new-project <namespace>
   ```

3. **Apply MySQL Resources**  
   ```bash
   oc apply -f infrastructure/k8s/mysql-secret.yaml
   oc apply -f infrastructure/k8s/mysql-pvc.yaml
   oc apply -f infrastructure/k8s/mysql-deployment.yaml
   oc apply -f infrastructure/k8s/mysql-service.yaml
   ```

4. **Initialize Database**  
   ```bash
   MYSQL_POD=$(oc get pod -l app=mysql -o jsonpath='{.items[0].metadata.name}')
   oc cp scripts/create_data.sql  $MYSQL_POD:/tmp/create_data.sql
   oc cp scripts/insert_data.sql  $MYSQL_POD:/tmp/insert_data.sql
   oc rsh $MYSQL_POD /opt/bitnami/mysql/bin/mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" -e "SOURCE /tmp/create_data.sql;"
   oc rsh $MYSQL_POD /opt/bitnami/mysql/bin/mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" -e "SOURCE /tmp/insert_data.sql;"
   ```

5. **Deploy FastAPI Service**  
   ```bash
   oc apply -f infrastructure/k8s/api-deployment.yaml
   oc apply -f infrastructure/k8s/api-service.yaml
   ```

6. **Expose API with Route**  
   ```bash
   oc expose svc/api
   ```

7. **Access API**  
   ```bash
   curl http://data-loader-api-<namespace>.apps.<cluster-domain>/data
   ```

---

## 📌 Example API Response

```json
[
  {"id": 1, "first_name": "David", "last_name": "Cohen"},
  {"id": 2, "first_name": "Ariel", "last_name": "Levy"},
  {"id": 3, "first_name": "Inon", "last_name": "Mizrahi"},
  {"id": 4, "first_name": "Eyal", "last_name": "Peretz"},
  {"id": 5, "first_name": "Moshe", "last_name": "Biton"}
]
```

---

## ✅ Requirements

- OpenShift Cluster (sandbox or enterprise)
- Docker (for building the API image)
- oc CLI
- Python 3.9+ (if testing locally)

---

## 👨‍💻 Author

Developed as part of a hands-on project to demonstrate **OpenShift deployments with FastAPI and MySQL**.
