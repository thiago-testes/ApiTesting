*** Settings ***
Resource     ../resources/api_testing_viacep.resource

*** Test Cases ***
Cenário 01: Testar um CEP válido e verificar se os dados retornados estão corretos
    Usar URL de chamada para retornar o CEP a ser consultado
    
Cenário 02: Testar se o CEP retornado pela API corresponde ao CEP consultado
    Verificar se o CEP consultado é retornado com sucesso

Cenário 03: Testar se a API retorna "erro": true para um CEP inexistente
    Usar CEP inválido que não existe para garantir resposta com erro

Cenário 04: Testar se a API retorna status 400 para um CEP com formato inválido
    Validar entradas que contêm caracteres não numéricos e verificar se são tratadas corretamente

Cenário 05: Testa se a API retorna status 400 para um CEP com menos de 8 dígitos
    Verificar resposta para CEP com menos de 8 dígitos

Cenário 05: Testa se a API retorna status 400 para um CEP com mais de 8 dígitos
    Verificar resposta para CEP com mais de 8 dígitos