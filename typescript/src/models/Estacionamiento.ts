import Auto from './Auto';
import LoteEstacionamiento from './LoteEstacionamiento';
import EstacionamientoLlenoException from 
'./EstacionamientoLlenoException';
import EstacionamientoVacioException from 
'./EstacionamientoVacioException';
import AutoNoEncontradoException from './AutoNoEncontradoException';

export default class Estacionamiento {
  private static readonly TOTAL_LUGARES_ESTACIONAMIENTO = 10;
  private lugares: LoteEstacionamiento[] = [];

  constructor() {
    for (let i = 0; i < Estacionamiento.TOTAL_LUGARES_ESTACIONAMIENTO; 
i++) {
      this.lugares.push(LoteEstacionamiento.generarLugarVacio());
    }
  }

  private lugaresDisponibles(): number {
    return this.lugares.filter(l => l.isEmpty()).length;
  }

  private encuentraPrimerLugarDisponible(): number {
    const idx = this.lugares.findIndex(l => l.isEmpty());
    if (idx === -1) throw new EstacionamientoLlenoException();
    return idx;
  }

  private encuentraPrimerLugarOcupado(): number {
    const idx = this.lugares.findIndex(l => !l.isEmpty());
    if (idx === -1) throw new EstacionamientoVacioException();
    return idx;
  }

  private encuentraPlacas(placas: string): number {
    const idx = this.lugares.findIndex(
      l => !l.isEmpty() && l.getAutoAsignado()?.placas === placas
    );
    if (idx === -1) throw new AutoNoEncontradoException(placas);
    return idx;
  }

  ingresaAuto(auto: Auto, entradaFecha: Date): number {
    if (this.lugaresDisponibles() > 0) {
      const idx = this.encuentraPrimerLugarDisponible();
      this.lugares[idx] = new LoteEstacionamiento(auto, entradaFecha);
      return this.lugaresDisponibles();
    }
    throw new EstacionamientoLlenoException();
  }

  retiraAuto(salidaFecha: Date): LoteEstacionamiento {
    const idx = this.encuentraPrimerLugarOcupado();
    const saliente = this.lugares[idx];
    saliente.fechaSalida = salidaFecha;
    this.lugares[idx] = LoteEstacionamiento.generarLugarVacio();
    return saliente;
  }

  retiraAutoPlaca(placa: string, salidaFecha: Date): LoteEstacionamiento {
    const idx = this.encuentraPlacas(placa);
    const saliente = this.lugares[idx];
    saliente.fechaSalida = salidaFecha;
    this.lugares[idx] = LoteEstacionamiento.generarLugarVacio();
    return saliente;
  }
}

