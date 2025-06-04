# 🇬🇧 How to Contribute to 21-000-000 Projects

Thank you for your interest in contributing to 21-000-000 organization projects! This document provides guidelines and best practices for contributors. Following these guidelines will ensure a smooth contribution process and help maintain high code quality.

## Table of Contents

- [Contribution Process](#contribution-process)
- [Pull Request and Code Review Rules](#pull-request-and-code-review-rules)
- [Coding Standards and Security Requirements](#coding-standards-and-security-requirements)
- [Specific Requirements for Bitcoin/Crypto Development](#specific-requirements-for-bitcoincrypto-development)
- [Testing and Validation Process](#testing-and-validation-process)
- [Documentation Guidelines](#documentation-guidelines)

## Contribution Process

1. **Find an issue or create a new one**
   - Browse existing issues to see if someone else is already working on a similar task
   - If you don't find an existing issue, create a new one with a clear description of the problem or feature

2. **Fork the repository**
   - Create a fork of the repository to your GitHub account

3. **Create a new branch**
   - Name your branch according to the convention: `type/brief-description`
   - Branch types: `feature`, `fix`, `docs`, `refactor`, `test`, `chore`, `security`
   - Example: `feature/wallet-backup` or `fix/transaction-fee-calculation`

4. **Implement changes**
   - Follow the [coding standards](#coding-standards-and-security-requirements)
   - Add tests covering the new functionality or fix
   - Add or update documentation as needed

5. **Commit your changes**
   - Use semantic commit messages: `type(scope): brief description`
   - Example: `fix(wallet): fix transaction fee calculation`
   - Keep commits small and focused on a single change

6. **Test your changes**
   - Run all tests and ensure they pass
   - For crypto projects, additionally [test on testnet](#specific-requirements-for-bitcoincrypto-development)

7. **Create a pull request**
   - Create a pull request from your branch to the main branch of the target repository
   - Fill out the pull request template
   - Assign appropriate labels and reviewers

## Pull Request and Code Review Rules

### Creating Pull Requests

- One PR should address one specific change or feature
- Use the provided [pull request template](../.github/PULL_REQUEST_TEMPLATE.md)
- Ensure the PR meets all the checklist items
- Link the PR to the relevant issue (use keywords like "Fixes #123" or "Closes #456")
- For larger changes, consider creating a [draft pull request](https://github.blog/2019-02-14-introducing-draft-pull-requests/) for early feedback

### Code Review Process

- Each PR must be approved by at least one team member
- For critical components (crypto, security), two approvals are required
- Be polite and constructive when providing feedback
- Comments should be specific and offer solutions where possible
- Reviewers should check:
  - Functionality (does it meet requirements?)
  - Security (see [security requirements](#coding-standards-and-security-requirements))
  - Test coverage
  - Code quality and adherence to standards
  - Documentation

## Coding Standards and Security Requirements

### General Coding Standards

- Follow stylistic conventions for the respective language
- Use consistent indentation and formatting
- Name variables, functions, and classes descriptively and meaningfully
- Avoid overly long functions (max 50 lines as a guideline)
- Keep files focused on a single responsibility
- Write self-explanatory code and add comments where logic is complex

### Security Requirements

- **No secrets in code** - Never embed keys, passwords, or other sensitive data in code
- **Validate inputs** - All user inputs must be validated before processing
- **Use up-to-date dependencies** - Regularly update dependencies to eliminate known vulnerabilities
- **Minimize permissions** - Use the principle of least privilege
- **Prevent common vulnerabilities** - Guard against SQL injection, XSS, CSRF, and other common vulnerabilities
- **Secure data storage** - Store sensitive data securely (hashing, encryption)
- **Logging** - Implement appropriate logging but never log sensitive data

## Specific Requirements for Bitcoin/Crypto Development

### Security Measures

- **Transaction verification** - Implement multiple verifications before sending transactions
- **Test networks** - Always use test networks (testnet, signet, regtest) during development and testing
- **Deterministic building** - Ensure reproducible builds to verify integrity
- **Code audit** - Critical components must undergo security audit
- **Side-channel prevention** - Prevent side-channel attacks during cryptographic operations

### Cryptocurrency Best Practices

- **Proper cryptography implementation** - Use verified cryptographic libraries
- **Transparent operations** - Implement transparent and verifiable operations
- **Censorship resistance** - Design systems resistant to censorship and content removal
- **Private keys** - Never store private keys in plaintext, prefer hardware solutions
- **Randomness** - Use cryptographically secure random number generators

## Testing and Validation Process

### Types of Tests

- **Unit tests** - Test individual components in isolation
- **Integration tests** - Test interactions between components
- **End-to-end tests** - Test overall functionality from a user perspective
- **Security tests** - Test resistance against known attacks
- **Testnet testing** - For crypto projects, test on appropriate test network

### Testing Best Practices

- **Boundary testing** - Test edge cases and unexpected inputs
- **Mocking** - Use mocks to simulate external dependencies
- **Automation** - All tests should be automated and runnable locally
- **Consistency** - Tests should be deterministic and provide consistent results
- **Coverage** - Strive for high code coverage with tests (>80%)

## Documentation Guidelines

### Types of Documentation

- **API documentation** - Detailed description of all public APIs
- **User documentation** - Tutorials and instructions for users
- **Technical documentation** - Architecture and internal workings for developers
- **Examples** - Sample implementations and usage

### Documentation Standards

- **Currency** - Documentation must be updated along with code
- **Clarity** - Write clearly and concisely, avoid jargon where not necessary
- **Structure** - Use consistent structure and formatting
- **Bilingualism** - Key documentation should be in both Czech and English
- **Markdown** - Use Markdown for easy maintenance and versioning

---

# 🇨🇿 Jak přispívat do projektů 21-000-000

Děkujeme za váš zájem přispět do projektů organizace 21-000-000! Tento dokument poskytuje pokyny a osvědčené postupy pro přispěvatele. Dodržování těchto pokynů zajistí hladký proces přispívání a pomůže udržet vysokou kvalitu kódu.

## Obsah

- [Proces přispívání](#proces-přispívání)
- [Pravidla pro pull requesty a code review](#pravidla-pro-pull-requesty-a-code-review)
- [Standardy kódování a bezpečnostní požadavky](#standardy-kódování-a-bezpečnostní-požadavky)
- [Specifické požadavky pro Bitcoin/krypto vývoj](#specifické-požadavky-pro-bitcoinkrypto-vývoj)
- [Proces testování a validace](#proces-testování-a-validace)
- [Pokyny pro dokumentaci](#pokyny-pro-dokumentaci)

## Proces přispívání

1. **Najděte issue nebo vytvořte nový**
   - Projděte si existující issues, zda někdo jiný již nepracuje na podobném úkolu
   - Pokud nenajdete existující issue, vytvořte nový s jasným popisem problému nebo funkce

2. **Forkněte repozitář**
   - Vytvořte fork repozitáře do svého GitHub účtu

3. **Vytvořte novou větev**
   - Pojmenujte větev podle konvence: `typ/stručný-popis`
   - Typy větví: `feature`, `fix`, `docs`, `refactor`, `test`, `chore`, `security`
   - Příklad: `feature/wallet-backup` nebo `fix/transaction-fee-calculation`

4. **Implementujte změny**
   - Dodržujte [standardy kódování](#standardy-kódování-a-bezpečnostní-požadavky)
   - Přidejte testy pokrývající novou funkčnost nebo opravu
   - Přidejte nebo aktualizujte dokumentaci podle potřeby

5. **Commitujte změny**
   - Používejte sémantické commit zprávy: `typ(oblast): stručný popis`
   - Příklad: `fix(wallet): oprava výpočtu transakčních poplatků`
   - Držte commity malé a zaměřené na jednu změnu

6. **Otestujte své změny**
   - Spusťte všechny testy a ujistěte se, že projdou
   - Pro krypto projekty navíc [otestujte na testovací síti](#specifické-požadavky-pro-bitcoinkrypto-vývoj)

7. **Vytvořte pull request**
   - Vytvořte pull request z vaší větve do hlavní větve cílového repozitáře
   - Vyplňte šablonu pull requestu
   - Přiřaďte odpovídající štítky a recenzenty

## Pravidla pro pull requesty a code review

### Vytváření Pull Requestů

- Jeden PR by měl řešit jednu konkrétní změnu nebo funkci
- Používejte poskytnutou [šablonu pull requestu](../.github/PULL_REQUEST_TEMPLATE.md)
- Ujistěte se, že PR splňuje všechny body v checklistu
- Propojte PR s příslušným issue (použijte klíčová slova jako "Fixes #123" nebo "Closes #456")
- Pro větší změny zvažte vytvoření [draft pull requestu](https://github.blog/2019-02-14-introducing-draft-pull-requests/) pro časnou zpětnou vazbu

### Code Review proces

- Každý PR musí být schválen alespoň jedním členem týmu
- Pro kritické komponenty (krypto, bezpečnost) jsou vyžadovány dvě schválení
- Buďte zdvořilí a konstruktivní při poskytování zpětné vazby
- Komentáře by měly být konkrétní a nabízet řešení, pokud je to možné
- Recenzenti by měli zkontrolovat:
  - Funkčnost (splňuje požadavky?)
  - Bezpečnost (viz [bezpečnostní požadavky](#standardy-kódování-a-bezpečnostní-požadavky))
  - Testovací pokrytí
  - Kvalitu kódu a dodržování standardů
  - Dokumentaci

## Standardy kódování a bezpečnostní požadavky

### Obecné standardy kódování

- Dodržujte stylistické konvence pro příslušný jazyk
- Používejte konzistentní odsazování a formátování
- Pojmenovávejte proměnné, funkce a třídy popisně a smysluplně
- Vyhněte se příliš dlouhým funkcím (max. 50 řádků jako vodítko)
- Držte soubory zaměřené na jednu odpovědnost
- Pište samovysvětlující kód a přidávejte komentáře tam, kde je logika složitá

### Bezpečnostní požadavky

- **Žádné tajné údaje v kódu** - Nikdy nevkládejte klíče, hesla nebo jiné citlivé údaje do kódu
- **Validujte vstupy** - Všechny uživatelské vstupy musí být validovány před zpracováním
- **Používejte aktuální závislosti** - Pravidelně aktualizujte závislosti pro odstranění známých zranitelností
- **Minimalizujte oprávnění** - Používejte princip nejnižších oprávnění
- **Zamezte běžným zranitelnostem** - Chraňte před SQL injection, XSS, CSRF a dalšími běžnými zranitelnostmi
- **Bezpečné uložení dat** - Citlivá data ukládejte bezpečně (hašování, šifrování)
- **Logování** - Implementujte vhodné logování, ale nikdy nelogujte citlivé údaje

## Specifické požadavky pro Bitcoin/krypto vývoj

### Bezpečnostní opatření

- **Transakční ověření** - Implementujte vícenásobná ověření před odesláním transakcí
- **Testovací sítě** - Vždy používejte testovací sítě (testnet, signet, regtest) během vývoje a testování
- **Deterministické buildování** - Zajistěte reprodukovatelné buildy pro ověření integrity
- **Audit kódu** - Kritické komponenty musí projít bezpečnostním auditem
- **Zamezení postranním kanálům** - Zabraňte útokům postranními kanály při kryptografických operacích

### Kryptoměnové best practices

- **Správná implementace kryptografie** - Používejte ověřené kryptografické knihovny
- **Transparentní operace** - Implementujte transparentní a ověřitelné operace
- **Odolnost vůči cenzuře** - Navrhujte systémy odolné vůči cenzuře a odebrání obsahu
- **Privátní klíče** - Nikdy neukládejte privátní klíče v čitelné podobě, preferujte hardware řešení
- **Náhodnost** - Používejte kryptograficky bezpečné generátory náhodných čísel

## Proces testování a validace

### Typy testů

- **Unit testy** - Testujte individuální komponenty izolovaně
- **Integrační testy** - Testujte interakce mezi komponentami
- **End-to-end testy** - Testujte celkovou funkčnost z perspektivy uživatele
- **Bezpečnostní testy** - Testujte odolnost proti známým útokům
- **Testování na testovací síti** - Pro krypto projekty testujte na odpovídající testovací síti

### Testovací best practices

- **Testování hranic** - Testujte hraniční případy a neočekávané vstupy
- **Mocking** - Používejte mocky pro simulaci externích závislostí
- **Automatizace** - Všechny testy by měly být automatizované a spustitelné lokálně
- **Konzistence** - Testy by měly být deterministické a poskytovat konzistentní výsledky
- **Pokrytí** - Usilujte o vysoké pokrytí kódu testy (>80%)

## Pokyny pro dokumentaci

### Typy dokumentace

- **Dokumentace API** - Detailní popis všech veřejných API
- **Uživatelská dokumentace** - Návody a pokyny pro uživatele
- **Technická dokumentace** - Architektura a vnitřní fungování pro vývojáře
- **Příklady** - Ukázkové implementace a použití

### Standardy dokumentace

- **Aktuálnost** - Dokumentace musí být aktualizována spolu s kódem
- **Jasnost** - Pište jasně a stručně, vyhněte se žargonu kde není nezbytný
- **Struktura** - Používejte konzistentní strukturu a formátování
- **Dvojjazyčnost** - Klíčová dokumentace by měla být v češtině i angličtině
- **Markdown** - Používejte Markdown pro jednoduchou údržbu a verzování
