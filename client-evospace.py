# Client for evospace-js
# Example in python
# Programmer : Luis Rodriguez
# Author: Luis Rodriguez

import barrister
import json
import random

def getRandomInt(vmin, vmax):
	return random.randint(vmin, vmax)

def createPopulation(size):
	new_individuals = []
	l_min = [10, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	l_max = [150, 80, 1, 1, 1, 1, 4, 1, 1, 1, 3, 1, 1, 2, 3]

	for i in range(0, size):
		chromosome = []
		for j in range(0, len(l_min)):
			chromosome.append(getRandomInt(l_min[j], l_max[j]))
		individual = {'chromosome': chromosome}
		new_individuals.append(individual)

	return {'sample_id': None, 'sample': new_individuals}

def evolveSample(sample):
	sample_id = sample['sample_id']
	noIndividuals = len(sample['sample'])	
	new_individuals = []
	
	for i in range(0, noIndividuals):
		chromosome = []
		onlyIndividual = sample['sample'][i]

		for j in range(0, len(onlyIndividual['chromosome'])):
			chromosome.append(onlyIndividual['chromosome'][j] + 100)
		individual = {'chromosome': chromosome}
		new_individuals.append(individual)

	return {'sample_id': sample_id, 'sample': new_individuals}

# Conexion con el Server
trans  = barrister.HttpTransport("http://localhost:1818/")
client = barrister.Client(trans)


# Parametros
namePop = "popTest"

# Crear, Inicializar y Preparar la Poblracion
result = client.namePopulations.createPopulation(namePop)
print result


# Insertar la Poblacion Inicial
putSample = createPopulation(50)
putSample = json.dumps(putSample)
PutSample = client.Population.put_sample(namePop, putSample)
print PutSample

# Leer los individuos (Array)
keys = client.Population.read_pop_keys(namePop)
print keys

# Leer una muestra de la poblacion
read = client.Population.read(namePop, 2)
read = json.loads(read)
print read


# Obtener una muestra
getSample = client.Population.get_sample(namePop,10)
getSample = json.loads(getSample)
print type(getSample),getSample['sample'][0]


# Evolucionar muestra
evolveSample = evolveSample(getSample)
evolveSample = json.dumps(evolveSample)
print evolveSample

# Regresar la muestra evolucionada
PutSample = client.Population.put_sample(namePop, evolveSample)
print PutSample