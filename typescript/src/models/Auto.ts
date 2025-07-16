export default class Auto {
  placas: string;
  color: string;
  anio: number;
  modelo: string;
  minusvalido: boolean;

  constructor(placas = "", color = "", anio = 1900, modelo = "", 
minusvalido = false) {
    this.placas = placas;
    this.color = color;
    this.anio = anio;
    this.modelo = modelo;
    this.minusvalido = minusvalido;
  }

  toString(): string {
    return `Auto: ${this.placas}`;
  }
}
