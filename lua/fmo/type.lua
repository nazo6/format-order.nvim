-- Formatter

--- @class fmo.Formatter
--- @field init_condition fun(): boolean Function to check whether this formatter should be intialized. This function is called only once. Main use case is to check if the formatter is installed.
--- @field buf_condition fun(bufnr: number): fmo.BufConditionResult Function to check whether this formatter should be used for the current buffer. This function is called for every file. Main use case is to check if the formatter is supported for the current file.
--- @field format fun(buf: number, opts: fmo.FormatOpts, cb: function)

--- @alias fmo.BufConditionResult {enabled:true, priority:number}|{enabled:false}

--- @class fmo.FormatOpts
--- @field async boolean?
--- @field dry_run boolean?

-- Integration

--- @class fmo.Integration
--- @field formatter_generator fun(generate_opts: fmo.FormatterSpecifier): fmo.Formatter|nil

-- Config

--- @class fmo.Config
--- @field filetypes table<string, fmo.FormatterSpecifierGroup>
--- - no_ft: Falls back to lsp format if certain filetype is not configured.
--- - no_formatter: Falls back to lsp format if no formatter is enabled.
--- Default: {no_ft = true, no_formatter = false}
--- @field fallback_lsp {no_ft: boolean?, no_formatter: boolean?}|nil

--- @class fmo.FormatterSpecifier
--- @field type "conform"|"lsp" Integration type
--- @field name string
--- @field root_pattern string[]? Used to find the root of the project. Ignored for "lsp" type.
--- @field filetypes string[]? Filetypes that this formatter supports. Ignored for "lsp" type.

--- @alias fmo.FormatterSpecifierGroup fmo.FormatterSpecifier[][][]
