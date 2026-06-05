// Prefer:
if tc.expectedErr != nil {
	require.ErrorIs(t, err, tc.expectedErr)
	return
}
require.NoError(t, err)
require.Equal(t, tc.expectedPurchases, purchases)

// Avoid:
if tc.expectedErr != nil {
	require.ErrorIs(t, err, tc.expectedErr)
} else {
	require.NoError(t, err)
	require.Equal(t, tc.expectedPurchases, purchases)
}
