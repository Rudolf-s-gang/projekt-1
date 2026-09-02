# Projekt 1 — pravidla pro Codex

Toto je společný projekt v Godotu 4.4. Členové týmu pracují v Godotu; Codex za ně bezpečně provádí synchronizaci, checkpoint commity, push a pull requesty.

## Základní bezpečnost

- Nikdy nepoužívej `git push --force`, `git reset --hard` ani nepřepisuj historii.
- Nikdy nevytvářej běžný commit přímo na `main` a nikdy automaticky neslučuj pull request.
- Nikdy nemaž, nestashuj ani nepřepisuj lokální změny bez výslovného souhlasu uživatele.
- Nikdy necommituj `.godot/`, buildy, exporty, `.env`, tokeny, hesla, klíče nebo lokální nastavení editoru.
- Před commitem zkontroluj `git status --short`, celý diff a staged diff. Stageuj pouze ověřené soubory explicitními cestami.
- Při konfliktu, podezřelém souboru nebo nesouvisejících změnách zastav Git operace a požádej o rozhodnutí.
- Mluv s uživatelem česky a Git vysvětluj jednoduše.

## Povel „začínám“

1. Ověř kořen repozitáře, remote `origin`, přihlášení `gh auth status`, dostupnost `origin/main`, oprávnění a stav automatické úlohy.
2. Spusť `git status --short`. Pokud existují lokální změny z předchozí práce, nic nepřepisuj a aktivuj bezpečnostní zámek.
3. Je-li adresář čistý, spusť `git switch main`, `git fetch origin` a `git pull --ff-only origin main`.
4. Ověř, že lokální `main` odpovídá `origin/main`.
5. Vytvoř větev `work/<github-uzivatel>-<YYYYMMDD-HHMM>`; název musí být ASCII, malými písmeny a s pomlčkami.
6. Vytvoř lokální stavový soubor `.git/ai-work-session` s názvem větve, časem začátku a časem posledního úspěšného checkpointu. Tento soubor nikdy necommituj.
7. Až po úspěchu všech kroků napiš: `✅ Projekt je aktuální, pracovní větev je připravená a můžeš začít v Godotu.`

## Automatický checkpoint

Naplánovaná úloha běží každých 60 minut přímo v lokálním projektu.

1. Pokud `.git/ai-work-session` neexistuje, nic neměň.
2. Ověř bezpečnostní podmínky níže a že aktuální větev odpovídá relaci a není `main`.
3. Pokud nejsou smysluplné změny, nevytvářej commit.
4. Prohlédni změny a spusť dostupnou Godot kontrolu. Preferuj `godot --headless --path . --editor --quit`, případně `godot4`.
5. Vytvoř checkpoint commit `chore: automatic work checkpoint` a pushni pouze aktivní pracovní větev.
6. Aktualizuj čas posledního úspěšného checkpointu v `.git/ai-work-session`.
7. Nevytvářej při každém checkpointu nový pull request.

## Povel „končím“

1. Ověř aktivní relaci, pracovní větev, GitHub přihlášení, remote, síť a oprávnění.
2. Zkontroluj změny a spusť dostupnou Godot kontrolu.
3. Pokud zbývají smysluplné změny, vytvoř výstižný commit ve formátu `<typ>: <popis>`. Typy: `feat`, `fix`, `refactor`, `art`, `audio`, `docs`, `test`, `chore`.
4. Pushni pracovní větev.
5. Pomocí `gh pr create` vytvoř pull request do `main`, nebo existující PR aktualizuj. Popis musí obsahovat `Co se změnilo`, `Jak bylo ověřeno` a `Rizika / poznámky`.
6. Pull request neslučuj.
7. Teprve po úspěšném pushi odstraň `.git/ai-work-session`.
8. Vrať výsledek kontrol, hash posledního commitu a odkaz na pull request.

## Bezpečnostní zámek

Zámek aktivuj, pokud platí alespoň jedna podmínka:

- projekt nebo Git repozitář není dostupný,
- `origin` chybí nebo ukazuje jinam než na společný repozitář,
- nefunguje GitHub přihlášení, síť, zápis nebo push,
- chybí `main`, lokální `main` nelze aktualizovat pomocí fast-forward nebo vznikl konflikt,
- uživatel pracuje na `main` během aktivní relace,
- aktuální větev neodpovídá `.git/ai-work-session`,
- automatická úloha je vypnutá, zmeškala běh nebo poslední úspěšný checkpoint je při aktivní relaci starší než 90 minut,
- objeví se tajný, podezřelý, nesouvisející nebo neočekávaně velký soubor,
- Godot nebo jiný proces právě zapisuje nekonzistentní soubory.

Při zámku zastav commit, push, pull i vytvoření PR. Nic nemaž, nestashuj a nepřepisuj. Zobraz:

`⛔ ZÁLOHOVÁNÍ NENÍ V BEZPEČNÉM STAVU`

Potom uveď problém, čas poslední úspěšné zálohy, zda jsou lokální změny zachované, a právě jeden bezpečný krok k nápravě. Dokud se problém nevyřeší, nikdy netvrď, že lze bezpečně začít nebo skončit.

Počítač ani aplikaci nelze kontrolovat, když jsou vypnuté. Po návratu proto vždy porovnej současný čas s posledním úspěšným checkpointem a při překročení 90 minut aktivuj zámek.
