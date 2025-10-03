package service

import (
	"errors"
	"sort"
	"strings"
	"unicode/utf8"

	"github.com/0x41gawor/dietonez/internal/service/model"
)

type ServiceSearch struct {
}

func NewServiceSearch() *ServiceSearch {
	return &ServiceSearch{}
}

func (s *ServiceSearch) Search(query string, items []model.SearchResult) ([]model.SearchResultWithScore, error) {
	if strings.TrimSpace(query) == "" {
		return nil, errors.New("empty query")
	}
	var scoredNames []model.SearchResultWithScore
	for _, item := range items {
		toReject, score := scoreOrReject(item.Name, query)
		if !toReject {
			scoredNames = append(scoredNames, model.SearchResultWithScore{
				SearchResult: item,
				Score:        score,
			})
		}
	}
	// Sort by score descending
	sort.Slice(scoredNames, func(i, j int) bool {
		return scoredNames[i].Score > scoredNames[j].Score
	})
	return scoredNames, nil
}

// internal
// Scores `word` based on the `query`.
// This function evaluates whether the `word` matches the `query` and assigns a score to the match.
// If the `word` does not qualify and must be rejected, the function returns (true, 0).
//
// When evaluating:
// - If the `word` matches the `query`, the function returns (false, score), where `score` represents how well the `word` matches the `query`.
// - If the `word` does not match the `query`, the function returns (true, 0).
func scoreOrReject(word string, query string) (bool, float32) {
	// normalization
	query = strings.ToLower(strings.TrimSpace(query))
	word = strings.ToLower(strings.TrimSpace(word))

	// Reject `word` if not even a single letter overlaps
	if !containsAtLeastOneLetter(word, query) {
		return true, 0
	}

	// Exact substring match
	if strings.Contains(word, query) {
		return false, 1.0
	}

	lenQ := utf8.RuneCountInString(query)
	lenW := utf8.RuneCountInString(word)

	// Jeśli query dłuższe niż word, zamieniamy rolę (okno przez krótsze nie ma sensu)
	shorter, longer := query, word
	lenS, lenL := lenQ, lenW
	if lenW < lenQ {
		shorter, longer = word, query
		lenS, lenL = lenW, lenQ
	}

	// przesuwamy okno po "longer"
	bestDist := float32(lenS) // max distance = długość krótszego stringa
	for i := 0; i <= lenL-lenS; i++ {
		sub := substringByRunes(longer, i, i+lenS)
		d := levenshteinDistance(sub, shorter)
		if d < bestDist {
			bestDist = d
		}
	}

	// Score: 1 - dist/len(shorter) (lepsze dopasowanie = wyższy score)
	score := 1 - (bestDist / float32(lenS))
	if score < 0 {
		score = 0
	}
	return false, score
}

// pomocnicza: wycina substring po runach
func substringByRunes(s string, start, end int) string {
	runes := []rune(s)
	if start < 0 {
		start = 0
	}
	if end > len(runes) {
		end = len(runes)
	}
	return string(runes[start:end])
}

// internal
// Checks if string `a` contains at least one letter of string `b`
// Returns false if not
func containsAtLeastOneLetter(a, b string) bool {
	for _, runeValue := range b {
		if strings.ContainsRune(a, runeValue) {
			return true
		}
	}
	return false
}

// Util
// Calculates the Levenshtein distance between two strings
func levenshteinDistance(s1, s2 string) float32 {
	if s1 == s2 {
		return 0
	}
	lenS1, lenS2 := len(s1), len(s2)
	if lenS1 == 0 {
		return float32(lenS2)
	}
	if lenS2 == 0 {
		return float32(lenS1)
	}

	// Initialize a 2D slice to store distances
	d := make([][]int, lenS1+1)
	for i := range d {
		d[i] = make([]int, lenS2+1)
	}

	// Populate the distances of transforming each prefix of s1 into an empty string
	for i := 0; i <= lenS1; i++ {
		d[i][0] = i
	}
	// Populate the distances of transforming an empty string into each prefix of s2
	for j := 0; j <= lenS2; j++ {
		d[0][j] = j
	}

	// Populate the rest of the matrix
	for i := 1; i <= lenS1; i++ {
		for j := 1; j <= lenS2; j++ {
			cost := 0
			if s1[i-1] != s2[j-1] {
				cost = 1
			}
			d[i][j] = min3(
				d[i-1][j]+1,      // deletion
				d[i][j-1]+1,      // insertion
				d[i-1][j-1]+cost, // substitution
			)
		}
	}

	return float32(d[lenS1][lenS2])
}

// Util
// min returns the minimum among three integers
func min3(a, b, c int) int {
	if a < b {
		if a < c {
			return a
		}
		return c
	}
	if b < c {
		return b
	}
	return c
}

// Util
// min returns the minimum among two integers
func min2(x, y int) int {
	if x < y {
		return x
	}
	return y
}

// Util
// max2 returns the maximum among two integers
func max2(x, y int) int {
	if x > y {
		return x
	}
	return y
}
