# Client for evospace-js
# Example in ruby
# Programmer : Luis Rodriguez
# Author: Luis Rodriguez

require 'barrister'
require 'json'

def getRandomInt(vmin, vmax)
	vRandom = Random.new
	return vRandom.rand(vmin..vmax)
end

def createPopulation(size)
	new_individuals = Array.new
	l_min = [10, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	l_max = [150, 80, 1, 1, 1, 1, 4, 1, 1, 1, 3, 1, 1, 2, 3]

	for i in 0..size
		chromosome = Array.new
		for j in 0..l_min.length-1
			chromosome.push(getRandomInt(l_min[j], l_max[j]))
		end
		individual = {chromosome: chromosome}
		new_individuals.push(individual)
	end

	return {sample_id: nil, sample: new_individuals}
end

def evolveSample(sample)
	sample_id = sample["sample_id"]
	noIndividuals = sample["sample"].length-1
	new_individuals = Array.new

	for i in 0..noIndividuals
		chromosome = Array.new
		onlyIndividual = sample["sample"][i]

		for j in 0..onlyIndividual["chromosome"].length-1
			chromosome.push(onlyIndividual["chromosome"][j] + 100)
		end
		individual = {chromosome: chromosome}
		new_individuals.push(individual)
	end

	return {sample_id: sample_id, sample: new_individuals}
end

# Conexion con el Server
trans = Barrister::HttpTransport.new("http://localhost:1818/")
client = Barrister::Client.new(trans)

# Parametros
namePop = "popTest"

# Crear, Inicializar y Preparar la Poblracion
result = client.namePopulations.createPopulation(namePop)
puts result

# Insertar la Poblacion Inicial
putSample = createPopulation(50)
putSample = putSample.to_json
PutSample = client.Population.put_sample(namePop, putSample)
puts PutSample

# Leer los individuos (Array)
keys = client.Population.read_pop_keys(namePop)
puts keys

# Leer una muestra de la poblacion
read = client.Population.read(namePop, 2)
read = JSON.parse(read)
puts read

# Obtener una muestra
getSample = client.Population.get_sample(namePop,10)
getSample = JSON.parse(getSample)
puts getSample

# Evolucionar muestra
evolveSample = evolveSample(getSample)
evolveSample = evolveSample.to_json
puts evolveSample

# Regresar la muestra evolucionada
putSample = client.Population.put_sample(namePop, evolveSample)
print putSample