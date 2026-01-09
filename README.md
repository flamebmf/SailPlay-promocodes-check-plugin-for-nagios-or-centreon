# SailPlay Promocodes Nagios Plugin

Nagios / Centreon plugin for monitoring available SailPlay promocodes via API v2.  
Плагин Nagios / Centreon для мониторинга количества доступных промокодов SailPlay через API v2.

---

## 🇬🇧 English

### Description

This plugin checks **enabled SailPlay promocode groups** and monitors how many unused promocodes are left.

It returns:
- **OK** — free promocodes are above warning threshold
- **WARNING** — free promocodes are below warning threshold
- **CRITICAL** — free promocodes are below critical threshold

The plugin also outputs **Nagios perfdata** for graphing.

---

### Features

- Checks all enabled promo groups  
- Configurable warning / critical thresholds  
- Store department support  
- Verbose logging mode  
- Fully compatible with Nagios and Centreon  
- Performance data output  

---

### Requirements

- Perl 5.10+
- Perl modules:
  - LWP::UserAgent
  - JSON
  - Getopt::Std
- Access to SailPlay API v2

---

### Installation

```bash
git clone https://github.com/<your-repo>/sailplay-nagios-plugin.git
cd sailplay-nagios-plugin
chmod +x sailplay_check.pl
```

Copy plugin to Nagios plugins directory:

```bash
cp sailplay_check.pl /usr/lib/nagios/plugins/
```

---

### Usage

```bash
./sailplay_check.pl -K <API_TOKEN> -d <STORE_DEPARTMENT_ID> -w <WARNING> -c <CRITICAL> -V
```

---

### Exit Codes

| Code | Status |
|----|--------|
| 0 | OK |
| 1 | WARNING |
| 2 | CRITICAL |
| 3 | UNKNOWN |

---

## 🇷🇺 Русский

### Описание

Плагин проверяет **активные группы промокодов SailPlay** и контролирует количество свободных промокодов.

Статусы:
- **OK** — свободных промокодов больше warning
- **WARNING** — меньше warning
- **CRITICAL** — меньше critical

Поддерживается вывод **perfdata** для Nagios / Centreon.

---

### Возможности

- Проверка всех enabled promo group  
- Настраиваемые пороги warning / critical  
- Поддержка store department  
- Подробное логирование  
- Совместимость с Nagios и Centreon  
- Perfdata для графиков  

---

### Требования

- Perl 5.10+
- Perl-модули:
  - LWP::UserAgent
  - JSON
  - Getopt::Std
- Доступ к SailPlay API v2

---

### Установка

```bash
git clone https://github.com/<your-repo>/sailplay-nagios-plugin.git
cd sailplay-nagios-plugin
chmod +x sailplay_check.pl
```

---

### Использование

```bash
./sailplay_check.pl -K <API_TOKEN> -d <STORE_DEPARTMENT_ID> -w <WARNING> -c <CRITICAL> -V
```

---

### Автор

Dmitry Akulich  
akulich.d@gmail.com

---

### License / Лицензия

MIT License
