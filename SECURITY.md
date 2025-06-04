# 🇬🇧 Security Policy

## Reporting Security Vulnerabilities

The security of our projects and protection of user data is our highest priority. We appreciate the security community's help in identifying potential vulnerabilities.

### Responsible Disclosure Process

If you discover a security vulnerability in any 21-000-000 organization project, please follow these steps:

1. **Do not disclose the vulnerability publicly** - Please do not report security issues via public GitHub issues.
2. **Send an email** to security@21ooo.ooo with the subject "SECURITY VULNERABILITY: [brief description]".
3. **Provide details** - In your email, include:
   - Type of vulnerability
   - Complete description of the issue
   - Steps to reproduce or proof-of-concept
   - Potential impact
   - Any suggestions for mitigation or fixes

We commit to the following response:

- Acknowledge receipt of your report within 48 hours
- Provide an estimate of when we expect to release a fix
- Keep you informed about the progress of the resolution
- Credit you in our acknowledgments list (if desired)

### Disclosure Timeline

Our disclosure policy is as follows:

1. Acknowledgment of report receipt within 48 hours
2. Initial assessment of severity and impact within 7 days
3. Target time for fixing critical vulnerabilities is 30 days or less
4. Public disclosure after a fix is released, typically with a 14-day window to allow users to update

## Security Best Practices for Bitcoin/Crypto Projects

When working with our projects, please adhere to the following security guidelines:

### Protecting Private Keys and Sensitive Data

- **Never embed private keys or seed phrases in code** - Not in comments, variables, configuration files, or anywhere else in code
- **Do not store sensitive information in git repositories** - Use .gitignore and avoid committing .env files or other configuration files containing secrets
- **Use environment variables** - For storing sensitive information in production environments
- **Implement proper encryption** - For storing any sensitive data that must be retained

### Development and Testing

- **Use test networks** - Always develop and test on test networks (testnet, signet) before moving to the main network (mainnet)
- **Separate testing and production environments** - Never mix test and production data or configurations
- **Conduct security audits** - Before deploying critical asset management features

### Working with Transactions and Blockchain Data

- **Implement thorough input validation** - Especially when working with addresses, transactions, and other blockchain data
- **Verify transactions multiple times** - Ensure multiple checks before signing or sending transactions
- **Implement rate limiting** - For sensitive operations that could be abused
- **Have a recovery plan** - In case of key compromise or other security incidents

## Supported Versions and Update Policy

### Supported Versions

| Version | Supported | Notes |
| ------- | --------- | ----- |
| 1.x     | ✅        | Full support |
| 0.x     | ⚠️        | Critical security fixes only |

### Security Update Policy

- Critical security updates are released as soon as possible after issue identification
- Security updates are clearly marked in release notes
- We recommend updating as soon as possible after a security update is released
- For older versions, we may provide backported fixes for critical vulnerabilities

## Contact Information

For reporting security issues, use:

- Email: security@21ooo.ooo
- PGP Key: [download from our keyserver](https://keys.21ooo.ooo/security.asc)
- Key fingerprint: `1234 5678 9ABC DEF0 1234 5678 9ABC DEF0 1234 5678`

For regular issues, please use standard GitHub issues.

---

# 🇨🇿 Bezpečnostní politika

## Nahlašování bezpečnostních zranitelností

Bezpečnost našich projektů a ochrana dat uživatelů je naší nejvyšší prioritou. Oceňujeme pomoc bezpečnostní komunity při odhalování potenciálních zranitelností.

### Proces zodpovědného nahlašování (Responsible Disclosure)

Pokud objevíte bezpečnostní zranitelnost v jakémkoliv projektu organizace 21-000-000, postupujte prosím podle těchto kroků:

1. **Neodhalujte zranitelnost veřejně** - Prosíme, nenahlašujte bezpečnostní problémy prostřednictvím veřejných GitHub issues.
2. **Zašlete email** na adresu security@21ooo.ooo s předmětem "BEZPEČNOSTNÍ ZRANITELNOST: [stručný popis]".
3. **Uveďte detaily** - V emailu popište:
   - Typ zranitelnosti
   - Úplný popis problému
   - Kroky k reprodukci nebo proof-of-concept
   - Potenciální dopad
   - Případné návrhy na zmírnění nebo opravu

Zavazujeme se k následujícímu postupu:

- Potvrdíme přijetí vašeho hlášení do 48 hodin
- Poskytneme odhad, kdy očekáváme vydání opravy
- Budeme vás informovat o postupu řešení
- Uvedeme vás v seznamu poděkování (pokud si to přejete)

### Časový rámec zveřejnění

Naše politika zveřejnění je následující:

1. Potvrzení přijetí hlášení do 48 hodin
2. Prvotní posouzení závažnosti a dopadu do 7 dnů
3. Cílový čas pro opravu kritických zranitelností je 30 dní nebo méně
4. Veřejné zveřejnění po vydání opravy, obvykle s 14denním odstupem, aby uživatelé měli čas na aktualizaci

## Bezpečnostní best practices pro Bitcoin/krypto projekty

Při práci s našimi projekty prosím dodržujte následující bezpečnostní zásady:

### Ochrana privátních klíčů a citlivých dat

- **Nikdy nevkládejte privátní klíče nebo seed fráze do kódu** - Ani do komentářů, proměnných, konfiguračních souborů nebo jiných míst v kódu
- **Neukládejte citlivé údaje v git repozitářích** - Používejte .gitignore a vyhněte se ukládání .env souborů nebo jiných konfiguračních souborů obsahujících tajné údaje
- **Používejte environment proměnné** - Pro ukládání citlivých údajů v produkčním prostředí
- **Implementujte vhodné šifrování** - Pro ukládání jakýchkoli citlivých dat, která musí být uchována

### Vývoj a testování

- **Používejte testovací sítě** - Vždy vyvíjejte a testujte na testovacích sítích (testnet, signet) než přejdete na hlavní síť (mainnet)
- **Oddělte testovací a produkční prostředí** - Nikdy nemíchejte testovací a produkční data nebo konfigurace
- **Provádějte bezpečnostní audity** - Před nasazením kritických funkcí týkajících se správy prostředků

### Práce s transakcemi a blockchain daty

- **Implementujte důkladnou validaci vstupu** - Zvláště při práci s adresami, transakcemi a jinými blockchain daty
- **Ověřujte transakce několikrát** - Zajistěte vícenásobné kontroly před podepsáním nebo odesláním transakcí
- **Implementujte rate limiting** - Pro citlivé operace, které by mohly být zneužity
- **Mějte plán na recovery** - Pro případ kompromitace klíčů nebo jiných bezpečnostních incidentů

## Podporované verze a politika aktualizací

### Podporované verze

| Verze | Podporována | Poznámky |
| ----- | ----------- | -------- |
| 1.x   | ✅          | Plná podpora |
| 0.x   | ⚠️          | Pouze kritické bezpečnostní opravy |

### Politika bezpečnostních aktualizací

- Kritické bezpečnostní aktualizace jsou vydávány co nejdříve po identifikaci problému
- Bezpečnostní aktualizace jsou jasně označeny v release notes
- Po vydání bezpečnostní aktualizace doporučujeme aktualizovat co nejdříve
- Pro starší verze můžeme poskytnout backportované opravy pro kritické zranitelnosti

## Kontaktní informace

Pro nahlášení bezpečnostních problémů použijte:

- Email: security@21ooo.ooo
- PGP Klíč: [stáhnout z našeho keyserveru](https://keys.21ooo.ooo/security.asc)
- Otisky klíče: `1234 5678 9ABC DEF0 1234 5678 9ABC DEF0 1234 5678`

Pro běžné problémy používejte standardní GitHub issues.