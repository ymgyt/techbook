# OAuth 2.0 Rich Authorization Requests

https://datatracker.ietf.org/doc/rfc9396/

OAuth 2.0(RFC6749)がlimited capabilityとして付与するscopeは静的なシナリオでは有効。
例えば、resource ownerのprofileへのread accessを付与

`authorization_details` parameterを追加して、`directory Aのreadとfile Xへのwrite権限`が必要を表現できるようにする

```json
{
      "type": "payment_initiation",
      "locations": [
         "https://example.com/payments"
      ],
      "instructedAmount": {
         "currency": "EUR",
         "amount": "123.50"
      },
      "creditorName": "Merchant A",
      "creditorAccount": {
         "bic":"ABCIDEFFXXX",
         "iban": "DE02100100109307118603"
      },
      "remittanceInformationUnstructured": "Ref Number Merchant"
}
```
