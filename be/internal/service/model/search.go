package model

type SearchResult struct {
	Id   int    `json:"id"`
	Name string `json:"name"`
}

type SearchResultWithScore struct {
	SearchResult
	Score float32 `json:"score"`
}
