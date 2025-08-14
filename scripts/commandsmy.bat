oc login וכו'...
oc delete all --all
oc delete pvc --all
oc delete configmap --all
oc delete secret --all
cd C:\PyCharm/openShift_SQL_docker_project/infrastructure/k8s
oc apply -f mysql-secret.yaml 
oc apply -f mysql-pvc.yaml 
oc apply -f mysql-deployment.yaml 
oc apply -f mysql-service.yaml
oc rollout status deployment/mysql 
oc get pod -l app=mysql
oc cp scripts/create_data.sql mysql-6fb47f55d8-2dcp8:/tmp/create_data.sql