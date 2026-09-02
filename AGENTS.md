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

1. Nejdřív polož uživateli přesně dvě krátké otázky a před odpovědí neprováděj žádné Git změny:
   - `Na čem budeš pracovat? Napiš krátký popis změny.`
   - `Chceš začít z aktuálního main, nebo pokračovat z jiné existující větve? Pokud z jiné, napiš její název.`
2. Z popisu práce vytvoř krátký ASCII identifikátor. Použij jej v názvu nové větve a jako kontext pro názvy checkpointů, závěrečného commitu a pull requestu. Nevymýšlej obsah změny, který uživatel neuvedl.
3. Ověř kořen repozitáře, remote `origin`, přihlášení `gh auth status`, oprávnění a stav automatické úlohy. Spusť `git status --short`. Pokud existují lokální změny z předchozí práce, nic nepřepisuj a aktivuj bezpečnostní zámek.
4. Vždy spusť `git fetch origin`, ale během aktivní práce automaticky nemerguj ani nerebasuj `main` do pracovní větve.
5. Pokud uživatel zvolil `main`, spusť `git switch main` a `git pull --ff-only origin main`. Ověř shodu s `origin/main` a vytvoř větev `work/<github-uzivatel>/<popis>-<YYYYMMDD-HHMM>`.
6. Pokud uživatel zvolil existující větev, ověř její přesný název lokálně nebo na `origin`, přepni se na ni a aktualizuj ji pouze fast-forwardem z odpovídající vzdálené větve. Nevytvářej náhradní větev a nepřimíchávej do ní `main`. Pokud větev neexistuje nebo fast-forward nelze provést, aktivuj bezpečnostní zámek.
7. Vytvoř lokální stavový soubor `.git/ai-work-session` s názvem větve, popisem práce, zvolenou základní větví, časem začátku a časem posledního úspěšného checkpointu. Tento soubor nikdy necommituj.
8. Až po úspěchu všech kroků napiš: `✅ Pracovní větev je připravená a můžeš začít v Godotu.` Uveď také název větve a z jaké větve práce vychází.

## Automatický checkpoint

Naplánovaná úloha běží každých 60 minut přímo v lokálním projektu.

1. Pokud `.git/ai-work-session` neexistuje, nic neměň.
2. Ověř bezpečnostní podmínky níže a že aktuální větev odpovídá relaci a není `main`.
3. Pokud nejsou smysluplné změny, nevytvářej commit.
4. Prohlédni změny a spusť dostupnou Godot kontrolu. Preferuj `godot --headless --path . --editor --quit`, případně `godot4`.
5. Vytvoř checkpoint commit `chore: checkpoint <kratky-popis-prace>` podle popisu uloženého v `.git/ai-work-session` a pushni pouze aktivní pracovní větev.
6. Aktualizuj čas posledního úspěšného checkpointu v `.git/ai-work-session`.
7. Nevytvářej při každém checkpointu nový pull request.

## Povel „končím“

1. Ověř aktivní relaci, pracovní větev, GitHub přihlášení, remote, síť a oprávnění.
2. Zkontroluj změny a spusť dostupnou Godot kontrolu.
3. Pokud zbývají smysluplné změny, vytvoř výstižný commit podle skutečného diffu a popisu práce z `.git/ai-work-session` ve formátu `<typ>: <popis>`. Typy: `feat`, `fix`, `refactor`, `art`, `audio`, `docs`, `test`, `chore`.
4. Pushni pracovní větev.
5. Vždy pomocí `gh pr create` vytvoř pull request do `main`, nebo existující PR aktualizuj. PR vytvoř i tehdy, když je větev za `main`; tuto skutečnost uveď v poznámkách. Popis musí obsahovat `Co se změnilo`, `Jak bylo ověřeno` a `Rizika / poznámky`.
6. Pull request neslučuj.
7. Teprve po úspěšném pushi odstraň `.git/ai-work-session`.
8. Vrať výsledek kontrol, hash posledního commitu a odkaz na pull request.

## Aktualizace main a konflikty

- Během běžné aktivní práce prováděj `fetch`, ale automaticky nemerguj ani nerebasuj nové změny z `main` do pracovní větve. Tím uživateli neměň projekt pod rukama uprostřed práce.
- Nevydávej menší počet synchronizací za prevenci konfliktů: odklad může konflikt pouze přesunout na konec a zvětšit ho. U práce delší než jeden den nebo při změnách stejných scén upozorni uživatele, že je vhodná řízená synchronizace.
- `končím` vždy vytvoří PR bez automatického slučování `main` do pracovní větve. GitHub potom ukáže, zda lze PR sloučit čistě.
- Pokud PR nemá konflikt, vlastník jej může po kontrole sloučit metodou squash.
- Pokud PR konflikt má, řeš jej v samostatné řízené relaci na pracovní větvi, nikdy přímo na `main`.
- Před řízenou synchronizací musí být pracovní adresář čistý a všechny změny commitnuté a pushnuté. Potom použij `git fetch origin` a merge `origin/main` do pracovní větve. Nepoužívej rebase na již sdílené větvi, protože by vyžadoval přepis historie.
- Pokud merge vyvolá konflikt, nic automaticky nevybírej jako `ours` nebo `theirs`. Vyjmenuj konfliktní soubory a vysvětli význam obou verzí. U `.tscn`, `.tres` a `project.godot` požádej vlastníka změny nebo vedoucího projektu o rozhodnutí. Po vyřešení spusť Godot kontrolu, vytvoř merge commit a pushni stejnou pracovní větev; PR se aktualizuje automaticky.
- Pokud nelze konflikt bezpečně vyřešit, použij `git merge --abort`, zachovej původní pracovní větev a aktivuj bezpečnostní zámek.

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
