*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String

*** Variables ***
${BASE_URL}    https://viacep.com.br/ws/

*** Keywords ***
Usar URL de chamada para retornar o CEP a ser consultado
    [Documentation]    Testa um CEP válido e verifica se os dados retornados estão corretos.
    ${response}=    GET    ${BASE_URL}01001000/json/    expected_status=200
    ${json}=    Convert To Dictionary    ${response.json()}
    Dictionary Should Contain Key    ${json}    logradouro
    ${logradouro}=    Get From Dictionary    ${json}    logradouro
    Should Be Equal As Strings    ${logradouro}    Praça da Sé
    Dictionary Should Contain Key    ${json}    localidade
    ${localidade}=    Get From Dictionary    ${json}    localidade
    Should Be Equal As Strings    ${localidade}    São Paulo
    Dictionary Should Contain Key    ${json}    uf
    ${uf}=    Get From Dictionary    ${json}    uf
    Should Be Equal As Strings    ${uf}    SP

Verificar se o CEP consultado é retornado com sucesso
    [Documentation]    Testa se o CEP retornado pela API corresponde ao CEP consultado.
    ${cep_consultado}=    Set Variable    01001000
    ${response}=    GET    ${BASE_URL}${cep_consultado}/json/    expected_status=200
    ${json}=    Convert To Dictionary    ${response.json()}
    ${cep_retornado}=    Get From Dictionary    ${json}    cep
    ${cep_retornado}=    Replace String    ${cep_retornado}    -    ${EMPTY}
    Should Be Equal As Strings    ${cep_retornado}    ${cep_consultado}

Usar CEP inválido que não existe para garantir resposta com erro
    [Documentation]    Testa se a API retorna "erro": true para um CEP inexistente.
    ${cep_inexistente} =    Set Variable    99999999
    ${response}=    GET    ${BASE_URL}${cep_inexistente}/json/
    Should Be Equal As Numbers    ${response.status_code}    200
    ${json}=    Convert To Dictionary    ${response.json()}
    Dictionary Should Contain Key    ${json}    erro
    ${erro}=    Get From Dictionary    ${json}    erro
    Should Be Equal As Strings    ${erro}    true

Validar entradas que contêm caracteres não numéricos e verificar se são tratadas corretamente
    [Documentation]    Testa se a API retorna status 400 para um CEP com formato inválido.
    ${cep_invalido} =    Set Variable    1234ABCD
    ${response}=    GET    ${BASE_URL}${cep_invalido}/json/    expected_status=any
    Should Be Equal As Numbers    ${response.status_code}    400

Verificar resposta para CEP com menos de 8 dígitos
    [Documentation]    Testa se a API retorna status 400 para um CEP com menos de 8 dígitos.
    ${cep_invalido} =    Set Variable    1234
    ${response}=    GET    ${BASE_URL}${cep_invalido}/json/    expected_status=any
    Should Be Equal As Numbers    ${response.status_code}    400

Verificar resposta para CEP com mais de 8 dígitos
    [Documentation]    Testa se a API retorna status 400 para um CEP com mais de 8 dígitos.
    ${cep_invalido} =    Set Variable    123456789
    ${response}=    GET    ${BASE_URL}${cep_invalido}/json/    expected_status=any
    Should Be Equal As Numbers    ${response.status_code}    400
