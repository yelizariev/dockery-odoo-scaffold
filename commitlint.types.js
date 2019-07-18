module.exports = {
    rules: {
        'scope-enum': [
            1,  // You can enforce this by setting this value to 2
            'always',
            [
                // Updates from the dockery-odoo-scaffold repo.
                // Use with `chore` type.
                'scaffold',
                // Occasional manipulations in the vendor context.
                // Changes should be done upstream + including patch here.
                'vendor',
                // You should define them per project organizing around
                // higher level the core concepts within your project.
                // Example: modules or general design concepts used in your src.
                'please-define-in-project-commitlint.types.js'
            ]
        ],
        'type-enum': [
            2,
            'always',
            [
                'fix',       // bug fix
                'feat',      // new feature
                'refactor',  // refactoring; no functional change
                'style',     // formatting; no code change
                'docs',      // changes to documentation
                'test',      // adding or refactoring tests; no production code change
                'runtime',   // modifying the runtime environment
                'chore',     // changes to tooling; no code change
                'mig',       // adding or refactoring migrations; no production code change
                'revert',    // revert erroneous comits of any kind
                'hack',      // temporary fix to make things move forward; please avoid it
            ]
        ]
    }
};
