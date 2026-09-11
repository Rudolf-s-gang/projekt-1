# Projekt 1 — pravidla pro Codex

Toto je společný projekt v Godotu 4.4. Členové týmu pracují v Godotu; Codex za ně bezpečně provádí synchronizaci, ruční zálohy, commity, push a pull requesty.

## Jednorázová instalace Git a GitHub CLI

Pokud členovi chybí `git` nebo `gh`, Codex mu podle operačního systému zobrazí odpovídající příkazy níže. Instalaci systémových balíčků nikdy nespouštěj bez jeho výslovného souhlasu.

### macOS s Homebrew

```bash
brew install git gh
```

Pokud Homebrew není nainstalovaný, Git lze získat také pomocí nástrojů Applu:

```bash
xcode-select --install
```

GitHub CLI je potom stále potřeba nainstalovat samostatně, například přes Homebrew příkazem `brew install gh`.

### Windows v PowerShellu

```powershell
winget install --id Git.Git -e --source winget
winget install --id GitHub.cli -e --source winget
```

### Debian nebo Ubuntu

```bash
sudo apt update
sudo apt install git gh
```

Po instalaci vždy ověř oba nástroje a přihlas vlastní GitHub účet člena:

```bash
git --version
gh --version
gh auth login -h github.com
gh auth status
```

Pokud některý příkaz pro daný systém nefunguje, nic neobcházej neověřeným instalačním skriptem. Otevři aktuální oficiální návod na `https://git-scm.com/install/` nebo `https://cli.github.com/` a požádej uživatele o schválení dalšího postupu.

## Vyhledání existujícího Godotu 4

Godot 4 už je na počítači člena nainstalovaný. Nikdy jej neinstaluj, neaktualizuj, neodinstalovávej ani neměň systémovou proměnnou `PATH`. Pouze read-only kontrolami najdi jeho spustitelný soubor a ověř verzi pomocí `--version`.

- Nejdřív zkus příkazy dostupné v `PATH`, například `godot`, `godot4` nebo odpovídající příkaz zjištěný systémovým vyhledáváním.
- Na macOS zkontroluj také běžné umístění `/Applications/Godot.app/Contents/MacOS/Godot` a uživatelovu složku `Applications`.
- Na Windows použij `Get-Command` a běžná umístění aplikací. Na Linuxu ověř také existující instalaci přes správce balíčků nebo Flatpak, ale nic neinstaluj.
- Neprohledávej bez omezení celý disk. Pokud Godot nenajdeš v běžných umístěních, požádej uživatele, aby vybral aplikaci Godot nebo zadal přesnou cestu ke spustitelnému souboru.
- Po naklonování ulož absolutní cestu ke spustitelnému souboru do lokálního souboru `.git/ai-local-config` jako `GODOT_EXECUTABLE=<absolutni-cesta>`. Soubor nikdy necommituj, nevkládej do něj žádné tajné údaje, nikdy jej nespouštěj ani nenačítej jako shellový skript a před každým použitím ověř, že cesta stále ukazuje na Godot 4.
- Cestu z `.git/ai-local-config` používej pro všechny headless kontroly v tomto lokálním projektu a při spuštění ji bezpečně cituj i tehdy, když obsahuje mezery. Pokud soubor nebo program chybí, zopakuj read-only hledání. Pokud dostupná verze není řady Godot 4, aktivuj bezpečnostní zámek.

## Základní bezpečnost

- Nikdy nepoužívej `git push --force`, `git reset --hard` ani nepřepisuj historii.
- Nikdy nevytvářej běžný commit přímo na `main` a nikdy neslučuj pull request.
- Neprováděj žádný `git merge` ani `git rebase`, a to ani na pracovní větvi. Konflikty pouze diagnostikuj a předej vlastníkovi projektu.
- Nikdy nemaž, nestashuj ani nepřepisuj lokální změny bez výslovného souhlasu uživatele.
- Nikdy necommituj `.godot/`, buildy, exporty, `.env`, tokeny, hesla, klíče nebo lokální nastavení editoru.
- Před commitem zkontroluj `git status --short`, celý diff a staged diff. Stageuj pouze ověřené soubory explicitními cestami.
- Při konfliktu, podezřelém souboru nebo nesouvisejících změnách zastav Git operace a požádej o rozhodnutí.
- Mluv s uživatelem česky a Git vysvětluj jednoduše.

## Rychlý režim pro „začínám“ a „končím“

Cílem je dokončit běžné spuštění nebo ukončení relace bez zbytečných čekání a opakovaného potvrzování. Bezpečnostní pravidla a bezpečnostní zámek mají vždy přednost před rychlostí.

- Pokud v `.git/ai-local-config` chybí nastavení `FAST_GIT_FLOW`, připoj k otázkám při nejbližším povelu `začínám` ještě jednu volbu ve stejné zprávě: `Chceš zapnout rychlý režim? V něm budu provádět běžné bezpečné kroky začínám a končím bez dalších textových potvrzení; při konfliktu, nejasnosti nebo riziku se vždy zastavím.` Uživatel odpoví na všechny otázky jedinou zprávou.
- Volbu ulož pouze lokálně do `.git/ai-local-config` jako `FAST_GIT_FLOW=true` nebo `FAST_GIT_FLOW=false`. Tento údaj je preference, nikoli oprávnění operačního systému nebo aplikace.
- Při zapnutí nabídni uživateli jednorázové trvalé povolení pouze pro úzce vymezené rutinní příkazy potřebné v tomto projektu: bezpečné Git kontroly, `fetch`, `pull --ff-only`, vytvoření nebo přepnutí pracovní větve, `add`, `commit`, běžný `push`, `gh auth status`, vytvoření či aktualizaci PR a headless kontrolu známým Godotem. Pokud rozhraní nabízí možnost typu „vždy povolit“ pro konkrétní příkaz nebo úzký prefix, vysvětli ji a nech ji uživatele zvolit osobně.
- Nikdy sám nevypínej ani neobcházej bezpečnostní potvrzení Codexu, operačního systému nebo GitHubu. Nikdy nežádej trvalé povolení pro obecný shell, mazání, instalaci, přístup k tajným údajům ani zakázané Git operace. Pokud trvalé povolení není dostupné, seskup požadavky na nezbytné minimum.
- Read-only kontroly a kroky již výslovně povolené v tomto pracovním postupu prováděj bez dodatečných textových otázek. Nezávislé kontroly spusť společně, neopakuj stejnou kontrolu bez důvodu a po změně stavu ověř pouze to, co se mohlo změnit.
- V rychlém režimu nevyžaduj potvrzení navrženého shrnutí při povelu `končím`, pokud shrnutí jednoznačně odpovídá úvodnímu popisu a skutečným změnám. Při rozporu, nejasném rozsahu nebo podezřelé změně se vždy zeptej a před odpovědí necommituj ani nepushuj.
- Zapnutí rychlého režimu nikdy nepovoluje merge, rebase, force push, commit na `main`, automatické řešení konfliktů ani jinou operaci zakázanou tímto souborem.

## Povel „začínám“

1. Nejdřív polož uživateli v jedné zprávě přesně dvě krátké otázky a před odpovědí neprováděj žádné Git změny. Pokud ještě není uložená volba rychlého režimu, připoj do stejné zprávy také otázku uvedenou v části „Rychlý režim pro začínám a končím“, aby uživatel odpověděl pouze jednou:
   - `Na čem budeš pracovat? Napiš krátký popis změny.`
   - `Chceš začít z aktuálního main, nebo pokračovat z jiné existující větve? Pokud z jiné, napiš její název.`
2. Z popisu práce vytvoř krátký ASCII identifikátor. Použij jej v názvu nové větve a jako kontext pro názvy checkpointů, závěrečného commitu a pull requestu. Nevymýšlej obsah změny, který uživatel neuvedl.
3. Ověř kořen repozitáře, remote `origin`, přihlášení `gh auth status` a oprávnění. Pokud už existuje `.git/ai-work-session`, nevytvářej další relaci a nabídni pokračování nebo bezpečné dokončení té stávající. Potom spusť `git status --short` ještě před přepnutím větve nebo stažením `main`.
4. Pokud bez aktivní relace najdeš lokální změny, proveď postup „Zapomenuté změny při začínám“ níže. Dokud tento postup neskončí volbou uživatele, nestahuj `main` a nevytvářej novou pracovní větev.
5. Vždy spusť `git fetch origin`, ale během aktivní práce automaticky nemerguj ani nerebasuj `main` do pracovní větve.
6. Pokud uživatel zvolil `main`, spusť `git switch main` a `git pull --ff-only origin main`. Ověř shodu s `origin/main` a vytvoř větev `work/<github-uzivatel>/<popis>-<YYYYMMDD-HHMM>`.
7. Pokud uživatel zvolil existující větev, ověř její přesný název lokálně nebo na `origin`, přepni se na ni a aktualizuj ji pouze fast-forwardem z odpovídající vzdálené větve. Nevytvářej náhradní větev a nepřimíchávej do ní `main`. Pokud větev neexistuje nebo fast-forward nelze provést, aktivuj bezpečnostní zámek.
8. Vytvoř lokální stavový soubor `.git/ai-work-session` s názvem větve, popisem práce, zvolenou základní větví, základním commitem a časem začátku. Tento soubor nikdy necommituj.
9. Až po úspěchu všech kroků napiš: `✅ Pracovní větev je připravená a můžeš začít v Godotu.` Uveď také název větve a z jaké větve práce vychází.

## Zapomenuté změny při „začínám“

Tento postup bezpečně zachrání práci, kterou člen udělal bez aktivní relace. Hodinová ani jiná automatická záloha se nepoužívá.

1. Ověř očekávaný `origin`, `gh auth status`, absenci probíhajícího merge, rebase nebo cherry-picku a zkontroluj celý diff, seznam souborů a jejich velikosti.
2. Zastav postup při tajném, podezřelém, nesouvisejícím, ignorovaném, zakázaném nebo neočekávaně velkém souboru. Nikdy nezahrnuj `.godot/`, buildy, exporty, `.env`, tokeny, hesla, klíče ani lokální nastavení editoru.
3. Ověř, že Godot právě nezapisuje nekonzistentní soubory, a spusť dostupnou Godot kontrolu pomocí cesty z `.git/ai-local-config`.
4. Z aktuálního `HEAD` vytvoř novou větev `rescue/<github-uzivatel>/zapomenute-zmeny-<YYYYMMDD-HHMMSS>`. Explicitními cestami stageuj pouze ověřené soubory a všechny nalezené změny ulož do právě jednoho lokálního commitu `chore: preserve changes found before session`. Tento commit nejdřív nepushuj.
5. Po úspěšném lokálním commitu nabídni právě tři možnosti: `pushnout záchrannou větev na GitHub a potom začít z aktuálního main`, `ponechat záchranný commit pouze lokálně a začít z aktuálního main`, nebo `pokračovat v zachráněné práci na záchranné větvi`.
6. Při první možnosti pushni pouze záchrannou větev. Při druhé ji nepushuj, ale zachovej ji lokálně. U obou možností potom bezpečně přepni na `main`, aktualizuj jej pouze pomocí fast-forward a pokračuj vytvořením nové pracovní větve. Při třetí možnosti vytvoř `.git/ai-work-session` pro záchrannou větev a nepřimíchávej do ní `main`.
7. Nikdy nevytvářej z rescue větve automaticky pull request, neslučuj ji a nemaž ji v rámci tohoto postupu. Pokud uživatel řekne „zahodit“, vysvětli, že commit zůstává bezpečně obnovitelný v lokální rescue větvi; skutečné smazání vyžaduje pozdější samostatné a výslovné potvrzení.
8. Při jakékoli nejasnosti aktivuj bezpečnostní zámek a nic necommituj ani nepushuj.

## Povel „záloha“

1. Pokud aktivní relace neexistuje, spusť postup „Zapomenuté změny při začínám“ a nevydávej jej za běžnou zálohu relace.
2. Ověř, že aktuální větev odpovídá `.git/ai-work-session`, není `main`, remote a přihlášení jsou správné a neprobíhá jiná Git operace.
3. Pokud nejsou smysluplné změny, nevytvářej commit a pouze stručně oznam, že je vše již uložené.
4. Zkontroluj celý diff, zakázané soubory a velikosti. Spusť Godot kontrolu pomocí cesty z `.git/ai-local-config`.
5. Explicitními cestami stageuj ověřené změny, zkontroluj staged diff, vytvoř commit `chore: checkpoint <kratky-popis-prace>` a pushni pouze aktivní pracovní větev.
6. Nevytvářej pull request. Vrať čas a hash záložního commitu.

## Povel „končím“

1. Ověř aktivní relaci, pracovní větev, GitHub přihlášení, remote, síť a oprávnění.
2. Zkontroluj celý skutečný výsledek práce od základního commitu uloženého v `.git/ai-work-session` po aktuální stav. Zahrň již vytvořené ruční záložní commity i dosud necommitované změny. Spusť dostupnou Godot kontrolu.
3. Z úvodního popisu práce a skutečných změn vytvoř krátké srozumitelné shrnutí. Pokud je `FAST_GIT_FLOW=true` a shrnutí jednoznačně odpovídá plánu i změnám, použij je bez další otázky a pokračuj. Jinak polož právě jednu potvrzovací otázku ve tvaru: `Podle změn jsi <shrnutí>. Je to správně? Pokud ne, napiš opravu.` Před vyžádanou odpovědí uživatele nevytvářej závěrečný commit, nepushuj a nevytvářej ani neupravuj pull request.
4. Pokud uživatel shrnutí opraví nebo doplní, použij jeho odpověď pouze v rozsahu, který odpovídá skutečným změnám. Pokud si odpověď a změny odporují, zastav Git operace a požádej o vysvětlení. Potvrzené nebo v rychlém režimu jednoznačně odvozené shrnutí použij pro název závěrečného commitu a popis pull requestu.
5. Pokud zbývají smysluplné necommitované změny, vytvoř výstižný commit podle skutečného diffu a potvrzeného nebo v rychlém režimu jednoznačně odvozeného shrnutí ve formátu `<typ>: <popis>`. Typy: `feat`, `fix`, `refactor`, `art`, `audio`, `docs`, `test`, `chore`.
6. Pushni pracovní větev.
7. Vždy pomocí `gh pr create` vytvoř pull request do `main`, nebo existující PR aktualizuj. PR vytvoř i tehdy, když je větev za `main`; tuto skutečnost uveď v poznámkách. Popis musí obsahovat `Co se změnilo`, `Jak bylo ověřeno` a `Rizika / poznámky`.
8. Pull request neslučuj.
9. Teprve po úspěšném pushi a vytvoření nebo aktualizaci pull requestu odstraň `.git/ai-work-session`.
10. Vrať výsledek kontrol, hash posledního commitu a odkaz na pull request.

## Aktualizace main a konflikty

- Během běžné aktivní práce prováděj `fetch`, ale automaticky nemerguj ani nerebasuj nové změny z `main` do pracovní větve. Tím uživateli neměň projekt pod rukama uprostřed práce.
- Nevydávej menší počet synchronizací za prevenci konfliktů: odklad může konflikt pouze přesunout na konec a zvětšit ho. U práce delší než jeden den nebo při změnách stejných scén upozorni uživatele, že je vhodná řízená synchronizace.
- `končím` vždy vytvoří PR bez automatického slučování `main` do pracovní větve. GitHub potom ukáže, zda lze PR sloučit čistě.
- Pokud PR nemá konflikt, vlastník jej může po kontrole sloučit metodou squash.
- Pokud PR konflikt má, neprováděj merge, rebase ani automatickou úpravu konfliktních souborů. Aktivuj bezpečnostní zámek.
- Pomocí read-only kontrol zjisti, které soubory se překrývají, a srozumitelně popiš rozdíl mezi pracovní větví a `origin/main`. U `.tscn`, `.tres` a `project.godot` výslovně upozorni na riziko poškození Godot scény nebo nastavení.
- Vrať vlastníkovi projektu název pracovní větve, odkaz na PR, seznam dotčených souborů a doporučený další postup. Samotné vyřešení a sloučení konfliktu musí provést vlastník nebo jiný výslovně pověřený člověk mimo tento automatický pracovní postup.
- Původní pracovní větev a její historii vždy zachovej beze změny.

## Bezpečnostní zámek

Zámek aktivuj, pokud platí alespoň jedna podmínka:

- projekt nebo Git repozitář není dostupný,
- `origin` chybí nebo ukazuje jinam než na společný repozitář,
- nefunguje GitHub přihlášení, síť, zápis nebo push,
- chybí `main`, lokální `main` nelze aktualizovat pomocí fast-forward nebo vznikl konflikt,
- uživatel pracuje na `main` během aktivní relace,
- aktuální větev neodpovídá `.git/ai-work-session`,
- objeví se tajný, podezřelý, nesouvisející nebo neočekávaně velký soubor,
- Godot nebo jiný proces právě zapisuje nekonzistentní soubory.

Při zámku zastav commit, push, pull i vytvoření PR. Nic nemaž, nestashuj a nepřepisuj. Zobraz:

`⛔ ZÁLOHOVÁNÍ NENÍ V BEZPEČNÉM STAVU`

Potom uveď problém, čas poslední úspěšné zálohy, zda jsou lokální změny zachované, a právě jeden bezpečný krok k nápravě. Dokud se problém nevyřeší, nikdy netvrď, že lze bezpečně začít nebo skončit.
