//
//  File.swift
//
//
//  Created by Adrián R on 30/1/24.
//

import Foundation

public protocol MediaRepository {
    func getVideo(with id: ContentId) async throws -> AppUserMedia
    func getAudio(with id: ContentId) async throws -> AppUserMedia
}

final class LiveMediaRepository: MediaRepository {
    func getAudio(with id: ContentId) async throws -> AppUserMedia {
        let dto = try await RecommendationAPI.getAudio(catalogId: id.catalogId)
        return try AppUserMedia(dto: dto)
    }

    func getVideo(with id: ContentId) async throws -> AppUserMedia {
        let dto = try await RecommendationAPI.getVideo(catalogId: id.catalogId)
        return try AppUserMedia(dto: dto)
    }
}

final class MockMediaRepository: MediaRepository {
    func getAudio(with id: ContentId) async throws -> AppUserMedia {
        AppUserMedia(
            type: .audio,
            id: .init(itemId: "", catalogId: ""),
            rating: .notRated,
            status: .noInteraction,
            bookmarked: true,
            headline: "Get moving with Recco",
            description: "When you're doing squats, keep your back in a neutral position. Don't flatten the curve of your lower back, and don't arch your back in the other direction. Make sure that your knees stay centered over your feet on the way down. Don't let your knees roll inward or outward. If you can't bend your knees to a 90-degree angle, simply go as low as you can. Use your arms for balance and support. Stop when you're fatigued or your form begins to suffer.<br/>For most people, one set of 12 to 15 repetitions is adequate.<br/>Remember, for best results, keep your back in a neutral position and your abdominal muscles tight during the exercise. Keep your knees centered over your feet on the way down. Also, remember to keep your movements smooth and controlled.",
            category: .exercise,
            disclaimer: "Recco does is not responsible of any use that is is reckless or gets out of context.",
            warning: "Please if your have a heart condition, call your doctor and ask if it would be fine for you to do this kind of work",
            dynamicImageResizingUrl: URL(string: "https://www.dexeus.com/blog/wp-content/uploads/2019/11/shutterstock_1495916660-1000x640.jpg"),
            imageAlt: "A person on the floor, doing exercise.",
            mediaUrl: URL(string: "https://github.com/rafaelreis-hotmart/Audio-Sample-files/raw/master/sample2.mp3")!,
            duration: 702,
            textIsTranscription: true
        )
    }

    func getVideo(with id: ContentId) async throws -> AppUserMedia {
        AppUserMedia(
            type: .video,
            id: .init(itemId: "", catalogId: ""),
            rating: .notRated,
            status: .noInteraction,
            bookmarked: true,
            headline: "Get moving with Recco",
            description: "When you're doing squats, keep your back in a neutral position. Don't flatten the curve of your lower back, and don't arch your back in the other direction. Make sure that your knees stay centered over your feet on the way down. Don't let your knees roll inward or outward. If you can't bend your knees to a 90-degree angle, simply go as low as you can. Use your arms for balance and support. Stop when you're fatigued or your form begins to suffer.<br/><br/>For most people, one set of 12 to 15 repetitions is adequate.<br/><br/>Remember, for best results, keep your back in a neutral position and your abdominal muscles tight during the exercise. Keep your knees centered over your feet on the way down. Also, remember to keep your movements smooth and controlled.",
            category: .exercise,
            disclaimer: "Recco does is not responsible of any use that is is reckless or gets out of context.",
            warning: "Please if your have a heart condition, call your doctor and ask if it would be fine for you to do this kind of work",
            dynamicImageResizingUrl: URL(string: "https://www.dexeus.com/blog/wp-content/uploads/2019/11/shutterstock_1495916660-1000x640.jpg"),
            imageAlt: "A person on the floor, doing exercise.",
            mediaUrl: URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")!,
            duration: 1003
        )
    }
}
