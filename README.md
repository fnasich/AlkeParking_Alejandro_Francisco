# AlkeParking_Francisco_Alejandro
Ejercicio Integrador Swift de Alkemy Academy realizado por Francisco Tomas Nasich y Alejandro Trejo.


# Ejercicio 1
**¿ Por qué se define vehicles como un Set?**
De esta forma se evita que haya vehículos duplicados ya que los Set evitan que se 
agregue un dato duplicado.


# Ejercicio 2
**¿Puede cambiar el tipo de vehículo en el tiempo? ¿Debe definirse 
como variable o como constante en Vehicle?**
El tipo de vehiculo con el que un vehiculo es creado no puede cambiar con el paso del 
tiempo, es por eso debe declararse como una constante en la Struct de Vehicle

**¿Qué elemento de control de flujos podría ser útil para determinar la tarifa de 
cada vehículo en la computed property: ciclo for, if o switch?**
Se podria utilizar un if o un switch, pero el mas indicado para hacer este tipo de tarea 
seria el switch.


# Ejercicio 3
**¿Dónde deben agregarse las propiedades, en Parkable, Vehicle o en 
ambos?**
Se deben de definir en el protocolo Parkable para tener un mejor orden cada que 
creemos una estructura con ese protocolo.
           
**La tarjeta de descuentos es opcional, es decir que un vehículo puede no tener 
una tarjeta y su valor será nil. ¿Qué tipo de dato de Swift permite tener este 
comportamiento?**
Los datos opcionales “?”


# Ejercicio 4
**El tiempo de estacionamiento dependerá de parkedTime y deberá 
computarse cada vez que se consulta, teniendo como referencia la fecha actual. 
¿Qué tipo de propiedad permite este comportamiento: lazy properties, 
computed properties o static properties?**
Las computed properties permiten que una varibale sea calculada cuando la usemos 
en nuestro código. 


# Ejercicio 7
**Se está modificando una propiedad de un struct ¿Qué consideración debe tenerse en la definición de la función?**
Se debe definir como una mutating function. Con esto, el método puede tener la capacidad de mutar los valores de las propiedades.


# Ejercicio 10
**¿Qué validación debe hacerse para determinar si el vehículo tiene descuento?**
Se debe asignar un valor opcional a la propiedad "discountCard" y luego en la función checkOut validar si contiene algun valor o no asignandole la implementación de "isEmpty".
