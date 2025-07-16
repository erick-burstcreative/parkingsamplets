import Auto from './Auto';

export default class LoteEstacionamiento {
  private static readonly LUGAR_VACIO = 'VACIO';

  static generarLugarVacio(): LoteEstacionamiento {
    return new LoteEstacionamiento();
  }

  static generarLugarMinusvalidoVacio(): LoteEstacionamiento {
    return new LoteEstacionamiento(true);
  }

  autoAsignado?: Auto;
  minusvalido: boolean;
  fechaEntrada: Date;
  fechaSalida: Date;

  private constructor(minusvalido = false) {
    this.minusvalido = minusvalido;
    this.fechaEntrada = new Date(0);
    this.fechaSalida = new Date(0);
  }

  constructor(autoAsignado: Auto, fechaHoraEntrada: Date);
  constructor(autoAsignado?: Auto, fechaHoraEntrada?: Date, minusvalido?: 
boolean) {
    if (autoAsignado instanceof Auto) {
      this.autoAsignado = autoAsignado;
      this.fechaEntrada = fechaHoraEntrada ?? new Date();
      this.minusvalido = minusvalido ?? false;
      this.fechaSalida = new Date(0);
    } else {
      // invoked through factory
      this.minusvalido = autoAsignado as unknown as boolean ?? false;
      this.fechaEntrada = new Date(0);
      this.fechaSalida = new Date(0);
    }
  }

  isEmpty(): boolean {
    return !this.autoAsignado;
  }

  getAutoAsignado(): Auto | undefined {
    return this.autoAsignado;
  }

  estanciaCalculo(): number {
    if (this.fechaSalida.getTime() === 0) {
      return 0;
    }
    return (this.fechaSalida.getTime() - this.fechaEntrada.getTime()) / 
1000;
  }

  toString(): string {
    return this.isEmpty() ? LoteEstacionamiento.LUGAR_VACIO : 
this.autoAsignado!.toString();
  }
}
