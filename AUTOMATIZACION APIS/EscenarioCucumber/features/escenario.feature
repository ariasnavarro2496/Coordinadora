Feature: Solicitud de recogida de productos

    Scenario: Crear una solicitud de recogida con todos los campos válidos
        Given el usuario está autenticado en el sistema de solicitudes de recogida
        When el usuario envía una solicitud de recogida con los siguientes datos:
            | campo              | valor                  |
            | direccion          | Cl 10 # 20 30          |
            | fechaRecogida      | 2024-09-12             |
            | nombreEntrega      | Juan                   |
            | apellidosEntrega   | Pérez                  |
            | celularEntrega     | 3012345678             |
            | emailUsuario       | juan.perez@example.com |
            | descripcionTipoVia | Kilómetro              |
            | aplicativo         | envios                 |
        Then la solicitud debería ser aceptada
        And el servicio debería devolver un código de respuesta 200 OK
        And el mensaje de respuesta debería indicar "Solicitud de recogida creada exitosamente"

Feature: Solicitud con la misma dirección y fecha ya registrada

    Scenario: Intentar crear una solicitud con la misma dirección y fecha ya registrada
        Given tengo datos de solicitud válidos con los siguientes valores:
            | direccion     | fechaRecogida | nombreEntrega | apellidosEntrega | celularEntrega | emailUsuario     | descripcionTipoVia | aplicativo |
            | Cl 10 # 20 30 | 2024-09-15    | prueba        | prueba1          | 3045677777     | anar.7@gmail.com | Kilómetro          | envios     |
        And ya existe una solicitud con la misma direccion y fechaRecogida
        When Envío una solicitud POST a "https://apiv2-test.coordinadora.com/recogidas/cm-solicitud-recogidas-ms/solicitud-recogida"
        Then el estado de la respuesta debe ser 400
        And la respuesta debe contener "error"

    Scenario: Intentar crear una solicitud de recogida con una fecha fuera del rango permitido
        Given el cliente proporciona los siguientes datos:
            | direccion       | fechaRecogida | nombreEntrega | apellidosEntrega | celularEntrega | emailUsuario          | descripcionTipoVia | aplicativo |
            | Calle Falsa 123 | 2024-09-20    | Marta         | Gómez            | 1122334455     | marta.gomez@email.com | Boulevard          | App3       |
        When se solicita la recogida
        Then la solicitud de recogida no debe ser permitida