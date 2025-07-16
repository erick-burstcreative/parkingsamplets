export default class EstacionamientoVacioException extends Error {
  constructor(message?: string) {
    super(message);
    this.name = 'EstacionamientoVacioException';
  }
}
