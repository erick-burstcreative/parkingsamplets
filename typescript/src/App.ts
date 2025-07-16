import Auto from './models/Auto';
import Estacionamiento from './models/Estacionamiento';
import EstacionamientoLlenoException from './models/EstacionamientoLlenoException';
import EstacionamientoVacioException from './models/EstacionamientoVacioException';
import AutoNoEncontradoException from './models/AutoNoEncontradoException';

function main(): void {
  const estacionamiento = new Estacionamiento();
  console.log('== Bienvenido al estacionamiento ==');

  try {
    estacionamiento.ingresaAuto(new Auto('194VPH'), new Date(2016, 9, 25));
    estacionamiento.ingresaAuto(new Auto('164BKE'), new Date(2016, 9, 25));
    let salida = estacionamiento.retiraAuto(new Date(2016, 9, 26));
    console.log(`${salida.toString()} tardo: ${salida.estanciaCalculo()} segundos`);
    salida = estacionamiento.retiraAutoPlaca('164BKE', new Date(2016, 9, 27));
    console.log(`${salida.toString()} tardo: ${salida.estanciaCalculo()} segundos`);
    salida = estacionamiento.retiraAutoPlaca('655PDD', new Date(2016, 9, 27));
  } catch (ex) {
    if (ex instanceof EstacionamientoLlenoException) {
      console.log('== Lo Siento Estacionamiento Lleno ==');
    } else if (ex instanceof EstacionamientoVacioException) {
      console.log('== Estacionamiento Vacio ==');
    } else if (ex instanceof AutoNoEncontradoException) {
      console.log('== Lo Siento Auto NO encontrado ==');
    }
  } finally {
    console.log('== Adios ==');
  }
}

main();
