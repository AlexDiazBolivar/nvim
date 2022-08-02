local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	return
end

require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
require("dap-python").test_runner = 'django'

dap.adapters.python = {
	type = "executable",
	command = "python",
	args = { "-m", "debugpy.adapter" },
}

table.insert(dap.configurations.python, {
	type = "python",
	request = "launch",
	name = "Django",
	program = vim.fn.getcwd() .. "/manage.py",
	args = { "runserver", "0.0.0.0:8001", "--noreload" },
	pythonPath = "venv/bin/python",
	django = "true",
	justMyCode = "true",
})

-- table.insert(dap.configurations.python, {
-- 	type = "python",
-- 	request = "launch",
-- 	name = "Django all tests",
-- 	program = vim.fn.getcwd() .. "/manage.py",
-- 	args = { "test" },
-- 	pythonPath = "venv/bin/python",
-- 	django = "true",
-- 	justMyCode = "true",
-- })

table.insert(dap.configurations.python, {
    name =  "Python: Debug Tests",
    type =  "python",
    request = "launch",
	  program = vim.fn.getcwd() .. "/manage.py",
	  args = { "test", "apps.services.tests.test_SOSD.SOSDTest.test__one_way_drop" },
    purpose = "debug-test",
    console = "integratedTerminal",
    justMyCode = "false",
    env = { DJANGO_SETTING_MODULE = "main_config.settings.base" }
})

dapui.setup({})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
