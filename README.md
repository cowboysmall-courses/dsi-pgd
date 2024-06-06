# MSc in Data Science

Coursework for the Data Science Institute's Data Science MSc Program



-----

**Table of Contents**

- [Development](#Development)
- [License](#license)
- [Sublime Text Configs](#Sublime Text Configs)


## Development

The best way to play with this code is to launch a hatch shell:

```console
> hatch shell
```

once the shell is up and running you can execute some code:

```console
> python -m cowboysmall.some_tool 
```


## License

any tools or scripts found within `dsi-msc` are distributed under the terms of the [MIT](https://spdx.org/licenses/MIT.html) license.



## Development Tools Configs


### Sublime Text General Settings

```json
{
    "color_scheme": "Packages/Agila Theme/Agila Oceanic Next.tmTheme",
    "darkmatter_sidebar_font_xlarge": true,
    "draw_centered": false,
    "draw_indent_guides": false,
    "ensure_newline_at_eof_on_save": true,
    "font_face": "Consolas",
    "font_size": 11,
    "hot_exit": "disabled",
    "ignored_packages":
    [
        "Vintage",
    ],
    "remember_open_files": false,
    "save_on_focus_lost": true,
    "scroll_past_end": false,
    "tab_size": 4,
    "theme": "Agila.sublime-theme",
    "theme_agila_sidebar_font_big": false,
    "theme_agila_sidebar_selected_entry_white": true,
    "theme_agila_sidebar_small": true,
    "translate_tabs_to_spaces": true,
    "trim_trailing_white_space_on_save": "all",
    "word_wrap": false,
    "index_files": true,
}

```


### Sublime Text SublimeLinter Settings

```json
{
    "linters": {
        "pycodestyle": {
            "filter_errors": [
                "E221", "E251", "E272", "E302", "E303", "E305", "E303", "E501",
                "W291", "W391"
            ]
        }
    }
}

```

