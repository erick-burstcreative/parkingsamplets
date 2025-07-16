export default class EstacionamientoLlenoException extends Error {
  constructor(message?: string) {
    super(message);
    this.name = 'EstacionamientoLlenoException';
  }
}
