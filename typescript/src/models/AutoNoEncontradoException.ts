export default class AutoNoEncontradoException extends Error {
  constructor(message?: string) {
    super(message);
    this.name = 'AutoNoEncontradoException';
  }
}
