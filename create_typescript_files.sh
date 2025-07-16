#!/bin/sh

# Create directory structure
mkdir -p "typescript/src/models"

# package.json
cat > "typescript/package.json" <<'JSON'
{
  "name": "typescript",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "build": "tsc"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "type": "commonjs"
}
JSON

# tsconfig.json
cat > "typescript/tsconfig.json" <<'JSON'
{
  "compilerOptions": {
    "target": "es2017",
    "module": "commonjs",
    "outDir": "dist",
    "rootDir": "src",
    "strict": true
  }
}
JSON

# src/index.ts
cat > "typescript/src/index.ts" <<'EOF'
export { default as Auto } from './models/Auto';
export { default as Estacionamiento } from './models/Estacionamiento';
export { default as LoteEstacionamiento } from 
'./models/LoteEstacionamiento';
export { default as AutoNoEncontradoException } from 
'./models/AutoNoEncontradoException';
export { default as EstacionamientoLlenoException } from 
'./models/EstacionamientoLlenoException';
export { default as EstacionamientoVacioException } from 
'./models/EstacionamientoVacioException';
EOF

# src/App.ts
cat > "typescript/src/App.ts" <<'EOF'
import Auto from './models/Auto';
import Estacionamiento from './models/Estacionamiento';
import EstacionamientoLlenoException from 
'./models/EstacionamientoLlenoException';
import EstacionamientoVacioException from 
'./models/EstacionamientoVacioException';
import AutoNoEncontradoException from 
'./models/AutoNoEncontradoException';

function main(): void {
  const estacionamiento = new Estacionamiento();
  console.log('== Bienvenido al estacionamiento ==');

  try {
    estacionamiento.ingresaAuto(new Auto('194VPH'), new Date(2016, 9, 
25));
    estacionamiento.ingresaAuto(new Auto('164BKE'), new Date(2016, 9, 
25));
    let salida = estacionamiento.retiraAuto(new Date(2016, 9, 26));
    console.log(`${salida.toString()} tardo: ${salida.estanciaCalculo()} 
segundos`);
    salida = estacionamiento.retiraAutoPlaca('164BKE', new Date(2016, 9, 
27));
    console.log(`${salida.toString()} tardo: ${salida.estanciaCalculo()} 
segundos`);
    salida = estacionamiento.retiraAutoPlaca('655PDD', new Date(2016, 9, 
27));
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
EOF

# src/models/Auto.ts
cat > "typescript/src/models/Auto.ts" <<'EOF'
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
EOF

# src/models/AutoNoEncontradoException.ts
cat > "typescript/src/models/AutoNoEncontradoException.ts" <<'EOF'
export default class AutoNoEncontradoException extends Error {
  constructor(message?: string) {
    super(message);
    this.name = 'AutoNoEncontradoException';
  }
}
EOF

# src/models/EstacionamientoLlenoException.ts
cat > "typescript/src/models/EstacionamientoLlenoException.ts" <<'EOF'
export default class EstacionamientoLlenoException extends Error {
  constructor(message?: string) {
    super(message);
    this.name = 'EstacionamientoLlenoException';
  }
}
EOF

# src/models/EstacionamientoVacioException.ts
cat > "typescript/src/models/EstacionamientoVacioException.ts" <<'EOF'
export default class EstacionamientoVacioException extends Error {
  constructor(message?: string) {
    super(message);
    this.name = 'EstacionamientoVacioException';
  }
}
EOF

# src/models/LoteEstacionamiento.ts
cat > "typescript/src/models/LoteEstacionamiento.ts" <<'EOF'
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
EOF

# src/models/Estacionamiento.ts
cat > "typescript/src/models/Estacionamiento.ts" <<'EOF'
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

