//
//  RequestManager.h
//  Actinver-IOS
//
//  Created by David Fernando Guia Orduña on 12/05/15.
//  Copyright (c) 2015. All rights reserved.


//http://10.10.100.18:8880/app_develop/actinver/jarxs/SecurityManagerRest/usm01.json
//187.237.42.162:8880/app_develop/
//#define BASE_URL_ACTINVER                               @"https://www.actinver.com/eActinver/jaxrs/"

//#define BASE_URL_ACTINVER                               @"http://10.10.111.3:9083/eActinverServices/jaxrs/"

//#define BASE_URL_ACTINVER                               @"http://172.16.11.156:9080/eActinverServices/jaxrs/"
//#define BASE_URL_ACTINVER                                 @"http://10.10.100.18:8880/app_develop/actinver/jarxs/"
#define BASE_URL_ACTINVER                                 @"http://54.187.219.128/android/jarxs/"
#define BASE_URL_QUICKBLOX                                @"http://otakulife.co"

//#define BASE_URL_ACTINVER                                 @"http://localhost/Actinver/"    // MIOS   http://localhost/Actinver/

//#define BASE_URL_ACTINVER                                 @"http://172.20.112.82:8080/actinver/jarxs/"    // SERVIDOR LUIS


#define USM01                                           @"SecurityManagerRest/usm01"         // Login y token.
#define USM06                                           @"SecurityManagerRest/usm06"         // Motor de re-direccionamiento.
#define PRN01                                           @"ClientConfigurationsRest/prn01"    // Obtiene correo electrónico.
#define PRA31                                           @"NotificationsAndAlertsRest/pra31"  // Envió correo electrónico.
#define PRC10                                           @"MovementsRest/prc10"               // Consulta movimientos.
#define PIV01                                           @"CompanyInformationRest/piv01"      // Recuperamos las opciones de quejas y aclaraciones.
#define PIV02                                           // AUN NO TIENE URL
#define PRA28                                           @"ClientRest/pra28"                  // Recuperamos el tipo de persona (Física o Moral).
#define BPS10                                           @"PortfolioRest/bps10"               // Para Banco - Asesorado.
#define BRI04                                           @"FixedTermInvestmentRest/bri04"     // Para Banco - Asesorado.
#define BRI04PRLV                                       @"FixedTermInvestmentRest/bri04PRLV" // Para Banco - Asesorado.
#define BRI04CEDE                                       @"FixedTermInvestmentRest/bri04CEDE" // Para Banco - Asesorado.
#define BPD06                                           @"PortfolioRest/bpd06"               // Para Banco - Asesorado: Mercado de Dinero.
#define PBC30                                           @"PortfolioRest/bpc30"               // Para Casa- Asesorado: Se obtiene Mercado de dinero, Sociedades de inversión y Mercado de capitales.

#define PRS01                                           @"StatementRest/prs01"               // Obtiene la URL del archivo Estado de Cuentas y Constancias fiscales.

#define PRS03                                           @"StatementRest/prs03"               // Estados de cuenta y Constancias fiscales disponibles.
#define USM04                                           @"SecurityManagerRest/usm04"         // Obtiene contratos de la cuenta.
#define PRD01                                           @"ContractRest/prd01"                // Servicio para obtener el mail y el número de teléfono del usuario.

#define SFT21                                           @"ActiPassManagementRest/sft21"      // Generar challenge.

#define USM02                                           @"SecurityManagerRest/usm02"         // Obtener token para contrato.

#define PRC09_BANCO                                     @"MovementsRest/prc09Banco"          // Obtener token para contrato.
#define PRC09                                           @"MovementsRest/prc09"                // Obtener token para contrato.

#define TSP03                                           @"BankingOpsRest/tsp03";             // Transferencias (producción)


#define PRC06                                           @"BalanceRest/prc06"                 // Servicio para el balance de los contratos.
#define BRP06                                           @"ServicesPaymentRest/brp06"         // Servicios Usuario.
#define BRP02                                           @"ServicesPaymentRest/brp02"         // Consulta de empresa de Recarga (3) y Telepeaje (1).   // TELEPEAGE
#define BRP02_1                                         @"ServicesPaymentRest/1/brp02"         // Consulta de empresa de Recarga (3) y Telepeaje (1). // RECARGA
#define BRP02_3                                         @"ServicesPaymentRest/3/brp02"         // Consulta de empresa de Recarga (3) y Telepeaje (1).
#define BRP02_2                                         @"ServicesPaymentRest/2/brp02"         // Alta de Servicios.

//http://54.187.219.128/android/jarxs/ServicesPaymentRest/1/brp02
//http://54.187.219.128/android/jarxs/ServicesPaymentRest/3/brp02

#define BRP08                                           @"ServicesPaymentRest/brp08"         // Pago del servicio.
#define BRC04                                           @"ContractRest/brc04"                // Servicio de las tarjetas de crédito.
#define BRC08                                           @"BankingOpsRest/brc08"              // Servicio para el pago de las tarjetas.
#define BRC06                                           @"BankingOpsRest/brc06"              // Alta TDC.
#define BRC03                                           @"ContractRest/brc03"                // Eliminar TDC.
#define BRC07                                           @"BankingOpsRest/brc07"              // Modificación TDC.
#define BRP10                                           @"ServicesPaymentRest/brp10"         // Pago de registro.
#define BRP05                                           @"ServicesPaymentRest/brp05"         // Elimina contratos.
#define BRP11                                           @"ServicesPaymentRest/brp11"         // Modificación de pago.
#define BRG01                                           @"CatalogsRest/brg01"                // Consultar bancos.
#define FBE01                                           @"ContractRest/fbe01"                // Proporciona una lista con el tipo de alta.
#define PRD03                                           @"ContractRest/prd03"                // Registrar Cuenta Destino.
#define PRD04                                           @"ContractRest/prd04"                // Eliminar cuentas destino contrato.
#define PRD05                                           @"ContractRest/prd05"                // Modificar cuentas destino contrato.
#define GAS01                                           @"relatedContractsRest/gas01"        // Modificar alias.
#define CFB01                                           @"ClientServiceRest/cfb01"           // Solicitud de contratos faltantes.
#define PRA03                                           @"SecurityRest/pra03"                // Cambio de contraseña.
#define PRA04                                           @"SecurityRest/pra04"                // Cambio de imagen y pregunta secreta.
#define PRA09                                           @"ClientConfigurationsRest/pra09"    // Cambio medio de notificaciones.
#define PRA12                                           @"SecurityRest/pra12"                // Lista de preguntas disponibles.
#define PRA05                                           @"SecurityRest/pra05"                // Lista de imágenes.
#define SFT23                                           @"ActiPassManagementRest/sft23"      // Validar challenge.
#define USM05                                           @"SecurityManagerRest/usm05"         // Logout.
#define SFT06                                           @"ActiPassManagementRest/sft06"      // Registro de usuario en safenet.
#define SFT22                                           @"ActiPassManagementRest/sft22"      // Registro de token.
#define SFT19                                           @"ActiPassManagementRest/sft19"      // Generar semilla para SofToken.
#define PRC01                                           @"ActiPassManagementRest/prc01"      // Información del token actual.
#define PRA07                                           @"ClientConfigurationsRest/pra07"    // Términos y condiciones.
#define PRA30                                           @"SecurityRest/pra30"                // Guardar datos de enrolamiento paso 2 y 3.
#define GAS001                                           @"relatedContractsRest/gas001"      // Términos y condiciones.
#define GAS01                                           @"relatedContractsRest/gas01"        // Términos y condiciones.
#define QBLOX                                           @"/api_videocall.php"                //login quickblox



