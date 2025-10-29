-- Config

--- @class fmo.Config
--- @field filetypes table<string, fmo.FileType>
--- - no_ft: Falls back to lsp format if certain filetype is not configured.
--- - no_formatter: Falls back to lsp format if no formatter is enabled.
--- Default: {no_ft = true, no_formatter = false}
--- @field fallback_lsp {no_ft: boolean?, no_formatter: boolean?}|nil

--- @class fmo.FileType
--- @field default (fmo.FormatterDef|fmo.FormatterDef[])?
--- @field [integer] fmo.FormatterGroup

--- @class fmo.FormatterGroup
--- @field buf_condition nil|fun(bufnr: number, current_enabled: fmo.FormatterDef[]): boolean
--- @field [integer] fmo.FormatterDef|fmo.FormatterDef[]

--- @class fmo.FormatterDef
--- @field type "conform"|"lsp" Integration type
--- @field name string
--- @field init_condition fmo.InitCondition? Function to check whether this formatter should be intialized. This function is called only once. Main use case is to check if the formatter is installed.
--- @field buf_condition fmo.BufCondition? Function to check whether this formatter should be used for the buffer. This function is called for every buffer.
--- @field root_pattern string[]? Used in buf_condition. Also used to determine priority.
--- @field filetypes string[]? Filetypes that this formatter supports. Used in buf_condition.

--- @alias fmo.BufCondition fun(bufnr: number): fmo.BufConditionResult
--- @alias fmo.BufConditionResult {enabled:true, priority:number}|{enabled:false}

--- @alias fmo.InitCondition fun(): boolean

-- Formatter

--- @class fmo.Formatter
--- @field init_condition fmo.InitCondition see fmo.FormatterSpecifier.init_condition
--- @field buf_condition fmo.BufCondition see fmo.FormatterSpecifier.root_pattern, fmo.FormatterSpecifier.filetypes
--- @field format fun(buf: number, opts: fmo.FormatOpts)

--- @class fmo.FormatOpts
--- @field async boolean? Warning: If multiple formatter is enabled, this may not work as expected.
--- @field timeout_ms number?
--- @field dry_run boolean?

-- Integration

--- @class fmo.Integration
--- @field formatter_generator fun(generate_opts: fmo.FormatterDef): fmo.Formatter|nil
