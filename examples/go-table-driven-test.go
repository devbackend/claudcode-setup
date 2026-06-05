tests := map[string]struct {
	input    string
	expected string
}{
	"empty input": {input: "", expected: ""},
	"normal case": {input: "foo", expected: "FOO"},
}
for name, tc := range tests {
	t.Run(name, func(t *testing.T) {
		// ...
	})
}
