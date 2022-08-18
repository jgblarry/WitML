##  TERRAFORM - DEPLOY - WIT ADVISOR
### Deploy IaaC.

##  BEFORE STARTING ##
* Disponer de conexión con el repositorio de terraform dispuesto en Gitlab.
* Instalar awscli en su última versión estable.
* Establecer las credenciales awscli del usuario "terraform" configuradas por default.
* Instalar terraform en la versión 0.13.2 "Estable 07/09/2020"
* Inicializar las variables de configuración en el fichero .tfvars

### 1- PREPARA EL FICHERO .tfvars

Se deben configurar las variables de uso global en este fichero. Antes de iniciar los despliegues se deben cargar las variables.

```
source terraform.tfvars
```

### 2- BUCKET-TERRAFORM-STATE

Este es el único stack que no exporta su fichero de estado a S3 ya que el será en adelante el destino de los ficheros tfstate de los restantes stack. Este estack crea adicionalmente una tabla de DynamoDB para controlar el bloqueo de los ficheros tfstate evitando corrucción en ejecuciones simultaneas.

```
terraform init
terraform plan -var-file=../terraform.tfvars
terraform apply -var-file=../terraform.tfvars -auto-approve
```

### 3- GENERAL DEPLOYMENT

Siguientes pasos...

```
terraform init
terraform plan -var-file=../terraform.tfvars
terraform apply -var-file=../terraform.tfvars -auto-approve
```

### 4- EXPORT OUTPUT TO GENERATE FILES

Descripción...

```
terraform output packer > ./modules/ec2/packer-ami/packer-ami.json
```

## Versiones

Para el versionado completo del proyecto usamos [GitLab](http://gitlab.com/).

## Autor

* **[Reinaldo León](https://www.linkedin.com/in/reinaldoleon/) ** 

## Licencia

Realizado por [WIT-ADVISOR](https://www.witadvisor.com/) como parte de la evolución de la plataforma y procesos de IT.

## Información

* Tel. +34 625 59 26 00